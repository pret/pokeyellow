CreditsTextPointers:
; entries correspond to CRED_* constants
	table_width 2
	dw CreditsText_Version
	dw CreditsText_Tajiri
	dw CreditsText_Oota
	dw CreditsText_Morimoto
	dw CreditsText_Watanabe
	dw CreditsText_Masuda
	dw CreditsText_Nishino
	dw CreditsText_Sugimori
	dw CreditsText_Nishida
	dw CreditsText_Miyamoto
	dw CreditsText_Kawaguchi
	dw CreditsText_Ishihara
	dw CreditsText_Yamauchi
	dw CreditsText_Zinnai
	dw CreditsText_Hishida
	dw CreditsText_Sakai
	dw CreditsText_Yamaguchi
	dw CreditsText_Yamamoto
	dw CreditsText_Taniguchi
	dw CreditsText_Nonomura
	dw CreditsText_Fuziwara
	dw CreditsText_Matsusima
	dw CreditsText_Tomisawa
	dw CreditsText_Kawamoto
	dw CreditsText_Kakei
	dw CreditsText_Tsuchiya
	dw CreditsText_Nakamura
	dw CreditsText_Yuda
	dw CreditsText_Pokemon
	dw CreditsText_Director
	dw CreditsText_Programmers
	dw CreditsText_CharacterDesign
	dw CreditsText_Music
	dw CreditsText_SoundEffects
	dw CreditsText_GameDesign
	dw CreditsText_MonsterDesign
	dw CreditsText_GameScenario
	dw CreditsText_ParametricDesign
	dw CreditsText_MapDesign
	dw CreditsText_Testing
	dw CreditsText_SpecialThanks
	dw CreditsText_Producer
	dw CreditsText_ExecutiveProducer
	dw CreditsText_Tamada
	dw CreditsText_Oota2
	dw CreditsText_Yoshikawa
	dw CreditsText_Oota23
	dw CreditsText_Yoshida
	dw CreditsText_Matsumiya
	dw CreditsText_Seya
	dw CreditsText_Sekine
	dw CreditsText_Shimamura
	dw CreditsText_Shimoyamada
	dw CreditsText_SuperMarioClub
	dw CreditsText_Izushi
	dw CreditsText_Nomura
	dw CreditsText_Harada
	dw CreditsText_Yamagami
	dw CreditsText_Nishimura
	dw CreditsText_Saeki
	dw CreditsText_Fuzii
	dw CreditsText_Shogakukan
	dw CreditsText_Ootani
	dw CreditsText_PikachuVoice
	dw CreditsText_USStaff
	dw CreditsText_USCoord
	dw CreditsText_Tilden
	dw CreditsText_Kawakami
	dw CreditsText_Nakamura2
	dw CreditsText_Shoemake
	dw CreditsText_Osborne
	dw CreditsText_Translation
	dw CreditsText_Ogasawara
	dw CreditsText_Iwata
	dw CreditsText_Izushi2
	dw CreditsText_Harada2
	dw CreditsText_Murakawa
	dw CreditsText_Fukui
	dw CreditsText_SuperMarioClub2
	dw CreditsText_Paad
	dw CreditsText_Producers
	dw CreditsText_Hosokawa
	dw CreditsText_Okubo
	dw CreditsText_Nakamichi
	dw CreditsText_Yoshimura
	dw CreditsText_Yamazaki
	assert_table_length NUM_CRED_STRINGS

CreditsText_Version:
	db -6, "YELLOW VERSION"
	next   "    STAFF@"
CreditsText_Tajiri:
	db -6, "SATOSHI TAJIRI@"
CreditsText_Oota:
	db -6, "TAKENORI OOTA@"
CreditsText_Morimoto:
	db -7, "SHIGEKI MORIMOTO@"
CreditsText_Watanabe:
	db -7, "TETSUYA WATANABE@"
CreditsText_Masuda:
	db -6, "JUNICHI MASUDA@"
CreditsText_Nishino:
	db -5, "KOHJI NISHINO@"
CreditsText_Sugimori:
	db -5, "KEN SUGIMORI@"
CreditsText_Nishida:
	db -6, "ATSUKO NISHIDA@"
CreditsText_Miyamoto:
	db -7, "SHIGERU MIYAMOTO@"
CreditsText_Kawaguchi:
	db -8, "TAKASHI KAWAGUCHI@"
CreditsText_Ishihara:
	db -8, "TSUNEKAZU ISHIHARA@"
CreditsText_Yamauchi:
	db -7, "HIROSHI YAMAUCHI@"
CreditsText_Zinnai:
	db -7, "HIROYUKI ZINNAI@"
CreditsText_Hishida:
	db -7, "TATSUYA HISHIDA@"
CreditsText_Sakai:
	db -6, "YASUHIRO SAKAI@"
CreditsText_Yamaguchi:
	db -7, "WATARU YAMAGUCHI@"
CreditsText_Yamamoto:
	db -8, "KAZUYUKI YAMAMOTO@"
CreditsText_Taniguchi:
	db -8, "RYOHSUKE TANIGUCHI@"
CreditsText_Nonomura:
	db -8, "FUMIHIRO NONOMURA@"
CreditsText_Fuziwara:
	db -7, "MOTOFUMI FUZIWARA@"
CreditsText_Matsusima:
	db -7, "KENJI MATSUSIMA@"
CreditsText_Tomisawa:
	db -7, "AKIHITO TOMISAWA@"
CreditsText_Kawamoto:
	db -7, "HIROSHI KAWAMOTO@"
CreditsText_Kakei:
	db -6, "AKIYOSHI KAKEI@"
CreditsText_Tsuchiya:
	db -7, "KAZUKI TSUCHIYA@"
CreditsText_Nakamura:
	db -6, "TAKEO NAKAMURA@"
CreditsText_Yuda:
	db -6, "MASAMITSU YUDA@"
CreditsText_Pokemon:
	db -3, "#MON@"
CreditsText_Director:
	db -3, "DIRECTOR@"
CreditsText_Programmers:
	db -5, "PROGRAMMERS@"
CreditsText_CharacterDesign:
	db -7, "CHARACTER DESIGN@"
CreditsText_Music:
	db -2, "MUSIC@"
CreditsText_SoundEffects:
	db -6, "SOUND EFFECTS@"
CreditsText_GameDesign:
	db -5, "GAME DESIGN@"
CreditsText_MonsterDesign:
	db -6, "MONSTER DESIGN@"
CreditsText_GameScenario:
	db -6, "GAME SCENARIO@"
CreditsText_ParametricDesign:
	db -7, "PARAMETRIC DESIGN@"
CreditsText_MapDesign:
	db -4, "MAP DESIGN@"
CreditsText_Testing:
	db -6, "PRODUCT TESTING@"
CreditsText_SpecialThanks:
	db -6, "SPECIAL THANKS@"
CreditsText_Producers:
	db -4, "PRODUCERS@"
CreditsText_Producer:
	db -3, "PRODUCER@"
CreditsText_ExecutiveProducer:
	db -8, "EXECUTIVE PRODUCER@"
CreditsText_Tamada:
	db -6, "SOUSUKE TAMADA@"
CreditsText_Oota2:
	db -5, "SATOSHI OOTA@"
CreditsText_Yoshikawa:
	db -6, "RENA YOSHIKAWA@"
CreditsText_Oota23:
	db -6, "TOMOMICHI OOTA@"
CreditsText_Matsumiya:
	db -8, "TOSHINOBU MATSUMIYA@"
CreditsText_Seya:
	db -5, "NOBUHIRO SEYA@"
CreditsText_Yoshida:
	db -7, "HIRONOBU YOSHIDA@"
CreditsText_Sekine:
	db -6, "KAZUHITO SEKINE@"
CreditsText_Shimamura:
	db -7, "KAZUSHI SHIMAMURA@"
CreditsText_Shimoyamada:
	db -9, "TERUYUKI SHIMOYAMADA@"
CreditsText_SuperMarioClub:
	db -9, "NCL SUPER MARIO CLUB@"
CreditsText_Izushi:
	db -7, "TAKEHIRO IZUSHI@"
CreditsText_Nomura:
	db -5, "FUZIKO NOMURA@"
CreditsText_Harada:
	db -6, "TAKAHIRO HARADA@"
CreditsText_Yamagami:
	db -7, "HITOSHI YAMAGAMI@"
CreditsText_Nishimura:
	db -8, "KENTAROU NISHIMURA@"
CreditsText_Saeki:
	db -5, "NAOKO SAEKI@"
CreditsText_Fuzii:
	db -5, "TAKAYA FUZII@"
CreditsText_Shogakukan:
	db -4, "SHOGAKUKAN"
	next   "PRODUCTION@"
CreditsText_Ootani:
	db -5, "IKUE OOTANI@"
CreditsText_PikachuVoice:
	db -6, "PIKACHU VOICE@"

	db -3, "××××××××@"
CreditsText_USStaff:
	db -7, "US VERSION STAFF@"
CreditsText_USCoord:
	db -7, "US COORDINATION@"
CreditsText_Tilden:
	db -5, "GAIL TILDEN@"
CreditsText_Kawakami:
	db -6, "NAOKO KAWAKAMI@"
CreditsText_Nakamura2:
	db -6, "HIRO NAKAMURA@"
CreditsText_Shoemake:
	db -6, "RANDY SHOEMAKE@"
CreditsText_Osborne:
	db -5, "SARA OSBORNE@"
CreditsText_Translation:
	db -7, "TEXT TRANSLATION@"
CreditsText_Ogasawara:
	db -6, "NOB OGASAWARA@"
CreditsText_Iwata:
	db -5, "SATORU IWATA@"
CreditsText_Izushi2:
	db -7, "TAKEHIRO IZUSHI@"
CreditsText_Harada2:
	db -7, "TAKAHIRO HARADA@"
CreditsText_Murakawa:
	db -7, "TERUKI MURAKAWA@"
CreditsText_Fukui:
	db -5, "KOHTA FUKUI@"
CreditsText_SuperMarioClub2:
	db -9, "NCL SUPER MARIO CLUB@"
CreditsText_Paad:
	db -5, "PAAD TESTING@"
CreditsText_Hosokawa:
	db -8, "TAKEHIKO HOSOKAWA@"
CreditsText_Okubo:
	db -5, "KENJI OKUBO@"
CreditsText_Nakamichi:
	db -7, "KIMIKO NAKAMICHI@"
CreditsText_Yoshimura:
	db -6, "KAMON YOSHIMURA@"
CreditsText_Yamazaki:
	db -6, "SAKAE YAMAZAKI@"
