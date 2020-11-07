#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define CHUNKID(b1, b2, b3, b4) \
	(uint32_t)((uint32_t)(b1) | ((uint32_t)(b2) << 8) | \
	((uint32_t)(b3) << 16) | ((uint32_t)(b4) << 24))

size_t file_size(FILE *f) {
	if (fseek(f, 0, SEEK_END) == -1) return 0;
	long f_size = ftell(f);
	if (f_size == -1) return 0;
	if (fseek(f, 0, SEEK_SET) == -1) return 0;
	return (size_t)f_size;
}

int32_t get_uint16le(uint8_t *data, size_t size, size_t i) {
	return i + 2 >= size ? -1 :
		(int32_t)data[i] | ((int32_t)data[i+1] << 8);
}

int64_t get_uint32le(uint8_t *data, size_t size, size_t i) {
	return i + 4 >= size ? -1 :
		(int64_t)data[i] | ((int64_t)data[i+1] << 8) |
		((int64_t)data[i+2] << 16) | ((int64_t)data[i+3] << 24);
}

uint8_t *wav2pcm(uint8_t *wavdata, size_t wavsize, size_t *pcmsize) {
	int64_t fourcc = get_uint32le(wavdata, wavsize, 0);
	if (fourcc != CHUNKID('R', 'I', 'F', 'F')) {
		fputs("WAV file does not start with 'RIFF'\n", stderr);
		return NULL;
	}

	int64_t waveid = get_uint32le(wavdata, wavsize, 8);
	if (waveid != CHUNKID('W', 'A', 'V', 'E')) {
		fputs("RIFF chunk does not start with 'WAVE'\n", stderr);
		return NULL;
	}

	size_t sample_offset = 0;
	int64_t num_samples = 0;

	size_t riffsize = (size_t)get_uint32le(wavdata, wavsize, 4) + 8;
	for (size_t i = 12; i < riffsize;) {
		int64_t chunkid = get_uint32le(wavdata, wavsize, i);
		int64_t chunksize = get_uint32le(wavdata, wavsize, i+4);
		i += 8;
		if (chunksize == -1) {
			fputs("failed to read sub-chunk size\n", stderr);
			return NULL;
		}

		// require 22050 Hz 8-bit PCM WAV audio
		if (chunkid == CHUNKID('f', 'm', 't', ' ')) {
			int32_t audio_format = get_uint16le(wavdata, wavsize, i);
			if (audio_format != 1) {
				fputs("WAV data is not PCM format\n", stderr);
				return NULL;
			}
			int32_t num_channels = get_uint16le(wavdata, wavsize, i+2);
			if (num_channels != 1) {
				fputs("WAV data is not mono\n", stderr);
				return NULL;
			}
			int64_t sample_rate = get_uint32le(wavdata, wavsize, i+4);
			if (sample_rate != 22050) {
				fputs("WAV data is not 22050 Hz\n", stderr);
				return NULL;
			}
			int32_t bits_per_sample = get_uint16le(wavdata, wavsize, i+14);
			if (bits_per_sample != 8) {
				fputs("WAV data is not 8-bit\n", stderr);
				return NULL;
			}
		}

		else if (chunkid == CHUNKID('d', 'a', 't', 'a')) {
			sample_offset = i;
			num_samples = chunksize;
			break;
		}

		i += (size_t)chunksize;
	}

	if (!num_samples) {
		fputs("WAV data has no PCM samples\n", stderr);
		return NULL;
	}

	// pack 8 WAV samples per PCM byte, clamping each to 0 or 1
	*pcmsize = (size_t)((num_samples + 7) / 8);
	uint8_t *pcmdata = malloc(*pcmsize);
	for (int64_t i = 0; i < num_samples; i += 8) {
		uint8_t v = 0;
		for (int64_t j = 0; j < 8 && i + j < num_samples; j++) {
			v |= (wavdata[sample_offset + i + j] > 0x80) << (7 - j);
		}
		pcmdata[i / 8] = v;
	}

	return pcmdata;
}

int main(int argc, char *argv[]) {
	if (argc != 3) {
		fprintf(stderr, "Usage: %s infile.wav outfile.pcm\n", argv[0]);
		return EXIT_FAILURE;
	}

	char *wavname = argv[1];
	char *pcmname = argv[2];

	FILE *wavfile = fopen(wavname, "rb");
	if (!wavfile) {
		fprintf(stderr, "failed to open for reading: '%s'\n", wavname);
		return EXIT_FAILURE;
	}

	size_t wavsize = file_size(wavfile);
	if (!wavsize) {
		fclose(wavfile);
		fprintf(stderr, "failed to get file size: '%s'\n", wavname);
		return EXIT_FAILURE;
	}

	uint8_t *wavdata = malloc(wavsize);
	size_t readsize = fread(wavdata, 1, wavsize, wavfile);
	fclose(wavfile);
	if (readsize != wavsize) {
		fprintf(stderr, "failed to read: '%s'\n", wavname);
		return EXIT_FAILURE;
	}

	size_t pcmsize;
	uint8_t *pcmdata = wav2pcm(wavdata, wavsize, &pcmsize);
	free(wavdata);
	if (!pcmdata) {
		fprintf(stderr, "failed to convert: '%s'\n", wavname);
		return EXIT_FAILURE;
	}

	FILE *pcmfile = fopen(pcmname, "wb");
	if (!pcmfile) {
		fprintf(stderr, "failed to open for writing: '%s'\n", pcmname);
		return EXIT_FAILURE;
	}

	size_t writesize = fwrite(pcmdata, 1, pcmsize, pcmfile);
	free(pcmdata);
	fclose(pcmfile);
	if (writesize != pcmsize) {
		fprintf(stderr, "failed to write: '%s'\n", pcmname);
		return EXIT_FAILURE;
	}

	return EXIT_SUCCESS;
}
