-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRC_TCR_ARCERROUTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRC_TCR_ARCERROUTPRO`;DELIMITER $$

CREATE PROCEDURE `PRC_TCR_ARCERROUTPRO`()
BEGIN

    DECLARE	Var_FecResp		DATE;
	DECLARE	Tipo_Reg		CHAR(7);
	DECLARE	Var_Consec		INT;
	DECLARE Tipo_Arc		CHAR(4);
	DECLARE Var_Folio		VARCHAR(6);
	DECLARE Max_Folio		INT;
	DECLARE Var_Registro	TEXT;
	DECLARE Var_NomArch		VARCHAR(30);
	DECLARE Tip_Tarjeta		CHAR(1);
    DECLARE Nom_ArchiGenerado VARCHAR(20);
    DECLARE NumLote			INT(11);


	DECLARE	Ent_Cero		INT;
	DECLARE Tipo_Header		CHAR(1);
	DECLARE Tipo_Detail		CHAR(1);
	DECLARE Tipo_Trailer	CHAR(1);
	DECLARE Tipo_Error		CHAR(1);
	DECLARE Tipo_Out		CHAR(1);
	DECLARE Var_Error		CHAR(4);
	DECLARE Var_Exito		CHAR(4);
	DECLARE Var_Header		CHAR(7);

	DECLARE Var_Trailer		CHAR(7);
	DECLARE	Sta_NO_Proces	CHAR(1);
	DECLARE Tip_ProdCred	CHAR(2);
	DECLARE Tip_ProdDebi	CHAR(2);
	DECLARE Tip_TarjCred	CHAR(1);
	DECLARE Tip_TarjDebi	CHAR(1);


	DECLARE Cur_ArchRespPro CURSOR FOR
    SELECT	Arc_NombreArch, Arc_Registro
    FROM TCR_ARCHRESPPROSA_TMP;

	SET	Ent_Cero		:= 0;
	SET	Tipo_Header		:= 'H';
	SET	Tipo_Detail		:= 'D';
	SET	Tipo_Trailer	:= 'T';
	SET	Tipo_Error		:= 'E';
	SET Tipo_Out		:= 'O';
	SET	Var_Error		:= 'ERRO';
	SET	Var_Exito		:= 'CARD';
	SET	Var_Header		:= 'HEADER ';
	SET	Var_Trailer		:= 'TRAILER';
	SET	Sta_NO_Proces	:= 'N';
	SET Tip_ProdCred	:= '10';
	SET	Tip_ProdDebi	:= '11';
	SET	Tip_TarjCred	:= 'C';
	SET	Tip_TarjDebi	:= 'D';

	SET	Var_FecResp	:= NOW();



    OPEN Cur_ArchRespPro;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH	Cur_ArchRespPro
                    INTO	Var_NomArch,	Var_Registro;
					BEGIN
					SET Tipo_Arc	= SUBSTRING(Var_NomArch, 9,4);
					SET Var_Folio	= CAST(SUBSTRING(Var_NomArch, 15,6) AS DECIMAL(6,0) );
					SET	Tipo_Reg	= SUBSTRING(Var_Registro,1,7);

                            IF (Tipo_Arc = Var_Error)
                            THEN

								IF(Tipo_Reg = Var_Header )
                                THEN
									INSERT INTO TCR_HEDTRAERR_ADM (
													Hte_FolioAr,	Hte_FecRes,	Hte_Tipo,
													Hte_Campo1,		Hte_Campo2,	Hte_Campo3,	Hte_Campo4,	Hte_Campo5,
													Hte_Campo6,		Hte_Campo7,	Hte_Campo8,	Hte_Campo9,	Hte_Campo10,
													Hte_Campo11,	Hte_Campo12,Hte_Status)

											VALUES( Var_Folio,		Var_FecResp,	Tipo_Header,
													SUBSTRING(Var_Registro,1,7),	SUBSTRING(Var_Registro,8,3),	SUBSTRING(Var_Registro,11,5),	SUBSTRING(Var_Registro,16,4),	SUBSTRING(Var_Registro,20,2),
													SUBSTRING(Var_Registro,22,6),	SUBSTRING(Var_Registro,28,4),	SUBSTRING(Var_Registro,32,12),	SUBSTRING(Var_Registro,44,8),	SUBSTRING(Var_Registro,52,16),
													SUBSTRING(Var_Registro,68,9),	SUBSTRING(Var_Registro,77,6),	Sta_NO_Proces  );
								END IF;


								IF (Tipo_Reg <> Var_Header AND Tipo_Reg <> Var_Trailer )
								THEN
									SET Var_Consec = ( SELECT IFNULL(MAX(Dae_Consecutivo),Ent_Cero)+ 1 FROM TCR_DETARCERR_ADM WHERE Dae_FolioAr = Var_Folio );

                                    INSERT INTO TCR_DETARCERR_ADM (	Dae_FolioAr,	Dae_FecRes,	Dae_Consecutivo,
													Dae_Campo1,		Dae_Campo2,	Dae_Campo3,	Dae_Campo4,	Dae_Campo5,
													Dae_Campo6,		Dae_Campo7,	Dae_Campo8,	Dae_Campo9,	Dae_Campo10,
													Dae_Campo11,	Dae_Campo12,Dae_Campo13,Dae_Campo14,Dae_Status )
											VALUES(Var_Folio,	Var_FecResp,	Var_Consec,
													SUBSTRING(Var_Registro,1,16),	SUBSTRING(Var_Registro,17,16),	SUBSTRING(Var_Registro,33,7),	SUBSTRING(Var_Registro,40,9),	SUBSTRING(Var_Registro,49,4),
													SUBSTRING(Var_Registro,53,4),	SUBSTRING(Var_Registro,57,5),	SUBSTRING(Var_Registro,62,2),	SUBSTRING(Var_Registro,64,30),	SUBSTRING(Var_Registro,94,2),
													SUBSTRING(Var_Registro,96,15),	SUBSTRING(Var_Registro,111,19),SUBSTRING(Var_Registro,130,7),	SUBSTRING(Var_Registro,137,4),	Sta_NO_Proces	);
								END IF;


								IF(Tipo_Reg = Var_Trailer )
                                THEN
									INSERT INTO TCR_HEDTRAERR_ADM (	Hte_FolioAr,	Hte_FecRes,	Hte_Tipo,
													Hte_Campo1,		Hte_Campo2,	Hte_Campo3,	Hte_Campo4,	Hte_Campo5,
													Hte_Campo6,		Hte_Campo7,	Hte_Campo8,	Hte_Campo9,	Hte_Campo10,
													Hte_Campo11,	Hte_Campo12,Hte_Status)
											VALUES( Var_Folio,	Var_FecResp,	Tipo_Trailer,
													SUBSTRING(Var_Registro,1,7),	SUBSTRING(Var_Registro,8,3),	SUBSTRING(Var_Registro,11,5),	SUBSTRING(Var_Registro,16,4),	SUBSTRING(Var_Registro,20,2),
													SUBSTRING(Var_Registro,22,6),	SUBSTRING(Var_Registro,28,4),	SUBSTRING(Var_Registro,32,12),	SUBSTRING(Var_Registro,44,8),	SUBSTRING(Var_Registro,52,16),
													SUBSTRING(Var_Registro,68,9),	SUBSTRING(Var_Registro,77,6),	Sta_NO_Proces);
                                END IF;

                            END IF;

                            IF (Tipo_Arc = Var_Exito)
                            THEN

                                IF(Tipo_Reg = Var_Header )
                                THEN


									INSERT INTO TCR_HEDTRAOUT_ADM (	Hto_FolioAr,	Hto_FecRes,	Hto_Tipo,
														Hto_Campo1,		Hto_Campo2,	Hto_Campo3,	Hto_Campo4,	Hto_Campo5,
														Hto_Campo6,		Hto_Campo7,	Hto_Campo8,	Hto_Campo9,	Hto_Campo10,
														Hto_Campo11,	Hto_Campo12,Hto_Status )
											VALUES( Var_Folio,		Var_FecResp,	Tipo_Header,
													SUBSTRING(Var_Registro,1,7),	SUBSTRING(Var_Registro,8,3),	SUBSTRING(Var_Registro,11,5),	SUBSTRING(Var_Registro,16,4),	SUBSTRING(Var_Registro,20,2),
													SUBSTRING(Var_Registro,22,6),	SUBSTRING(Var_Registro,28,4),	SUBSTRING(Var_Registro,32,12),	SUBSTRING(Var_Registro,44,8),	SUBSTRING(Var_Registro,52,16),
													SUBSTRING(Var_Registro,68,9),	SUBSTRING(Var_Registro,77,6),	Sta_NO_Proces  );
								END IF;


                                IF (Tipo_Reg <> Var_Header AND Tipo_Reg <> Var_Trailer )
                                THEN
									SET Var_Consec = ( SELECT IFNULL(MAX(Dao_Consecutivo), Ent_Cero)+ 1 FROM TCR_DETARCOUT_ADM WHERE Dao_FolioAr = Var_Folio );
										IF (SUBSTRING(Var_Registro,62,2) = Tip_ProdCred )
                                        THEN
											SELECT Tip_Tarjeta	= Tip_TarjCred;

										ELSE
                                        IF(SUBSTRING(Var_Registro,62,2) = Tip_ProdDebi )
										THEN
												SET Tip_Tarjeta	= Tip_TarjDebi;
										END IF;

                                    SET Nom_ArchiGenerado	:= SUBSTRING(Var_NomArch,1,20);
                                    SET NumLote				:= (SELECT LoteDebitoID FROM LOTETARJETADEB WHERE NomArchiGen= Nom_ArchiGenerado);

									INSERT	INTO TCR_DETARCOUT_ADM (	Dao_FolioAr,	Dao_FecRes,		Dao_Consecutivo,	Dao_NomArchiGen,	Dao_NumLote,
																		Dao_Campo1,		Dao_Campo2,		Dao_Campo3,			Dao_Campo4,			Dao_Campo5,
																		Dao_Campo6,		Dao_Campo7,		Dao_Campo8,			Dao_Campo9,			Dao_Campo10,
																		Dao_Campo11,	Dao_Campo12,	Dao_Campo13,		Dao_Campo14,		Dao_Campo15,
																		Dao_Campo16,	Dao_Campo17,	Dao_Campo18,		Dao_Campo19,		Dao_Campo20,
																		Dao_Campo21,	Dao_Campo22,	Dao_Campo23,		Dao_Campo24,		Dao_Campo25,
																		Dao_Campo26,	Dao_Campo27,	Dao_Campo28,		Dao_Campo29,		Dao_Campo30,
																		Dao_Campo31,	Dao_Campo32,	Dao_Campo33,		Dao_Campo34,		Dao_Campo35,
																		Dao_Campo36,	Dao_Campo37,	Dao_Campo38,		Dao_Campo39,		Dao_Campo40,
																		Dao_Campo41,	Dao_Campo42,	Dao_Campo43,		Dao_Campo44,		Dao_Campo45,
																		Dao_Campo46,	Dao_Campo47,	Dao_Campo48,		Dao_Campo49,		Dao_Campo50,
																		Dao_Campo51,	Dao_Campo52,	Dao_Campo53,		Dao_Campo54,		Dao_Campo55,
																		Dao_Campo56,	Dao_Campo57,	Dao_Campo58,		Dao_Campo59,		Dao_Campo60,
																		Dao_Campo61,	Dao_Campo62,	Dao_Campo63,		Dao_Campo64,		Dao_Campo65,
																		Dao_Campo66,	Dao_Campo67,	Dao_Campo68,		Dao_Campo69,		Dao_Campo70,
																		Dao_Campo71,	Dao_Campo72,	Dao_Campo73,		Dao_Campo74,		Dao_Campo75,
																		Dao_Status,		Dao_TipoTarjeta )

                                            VALUES(						Var_Folio,		Var_FecResp,	Var_Consec,			Nom_ArchiGenerado,	NumLote,
												SUBSTRING(Var_Registro,1,16),	SUBSTRING(Var_Registro,17,16),	SUBSTRING(Var_Registro,33,7),	SUBSTRING(Var_Registro,40,9),	SUBSTRING(Var_Registro,49,4),
												SUBSTRING(Var_Registro,53,4),	SUBSTRING(Var_Registro,57,5),	SUBSTRING(Var_Registro,62,2),	SUBSTRING(Var_Registro,64,30),	SUBSTRING(Var_Registro,94,2),
												SUBSTRING(Var_Registro,96,15),	SUBSTRING(Var_Registro,111,19),	SUBSTRING(Var_Registro,130,19),	SUBSTRING(Var_Registro,149,7),	SUBSTRING(Var_Registro,156,8),
												SUBSTRING(Var_Registro,164,8),	SUBSTRING(Var_Registro,172,15),	SUBSTRING(Var_Registro,187,2),	SUBSTRING(Var_Registro,189,4),	SUBSTRING(Var_Registro,193,6),
												SUBSTRING(Var_Registro,199,2),	SUBSTRING(Var_Registro,201,1),	SUBSTRING(Var_Registro,202,27),	SUBSTRING(Var_Registro,229,25),	SUBSTRING(Var_Registro,254,16),
												SUBSTRING(Var_Registro,270,79),	SUBSTRING(Var_Registro,349,40),	SUBSTRING(Var_Registro,389,16),	SUBSTRING(Var_Registro,405,8),	SUBSTRING(Var_Registro,413,16),
												SUBSTRING(Var_Registro,429,1),	SUBSTRING(Var_Registro,430,2),	SUBSTRING(Var_Registro,432,2),	SUBSTRING(Var_Registro,434,2),	SUBSTRING(Var_Registro,436,8),
												SUBSTRING(Var_Registro,444,25),	SUBSTRING(Var_Registro,469,25),	SUBSTRING(Var_Registro,494,1),	SUBSTRING(Var_Registro,495,2),	SUBSTRING(Var_Registro,497,60),
												SUBSTRING(Var_Registro,557,4),	SUBSTRING(Var_Registro,561,4),	SUBSTRING(Var_Registro,565,2),	SUBSTRING(Var_Registro,567,15),	SUBSTRING(Var_Registro,582,10),
												SUBSTRING(Var_Registro,592,4),	SUBSTRING(Var_Registro,596,1),	SUBSTRING(Var_Registro,597,2),	SUBSTRING(Var_Registro,599,2),	SUBSTRING(Var_Registro,601,30),
												SUBSTRING(Var_Registro,631,16),	SUBSTRING(Var_Registro,647,2),	SUBSTRING(Var_Registro,649,127),SUBSTRING(Var_Registro,776,4),	SUBSTRING(Var_Registro,780,4),
												SUBSTRING(Var_Registro,784,10),	SUBSTRING(Var_Registro,794,1),	SUBSTRING(Var_Registro,795,1),	SUBSTRING(Var_Registro,796,40),	SUBSTRING(Var_Registro,836,40),
												SUBSTRING(Var_Registro,876,2),	SUBSTRING(Var_Registro,878,60),	SUBSTRING(Var_Registro,938,60),	SUBSTRING(Var_Registro,998,5),	SUBSTRING(Var_Registro,1003,1),
												SUBSTRING(Var_Registro,1004,1),	SUBSTRING(Var_Registro,1005,1),	SUBSTRING(Var_Registro,1006,7),	SUBSTRING(Var_Registro,1013,2),	SUBSTRING(Var_Registro,1015,1),
												SUBSTRING(Var_Registro,1016,1),	SUBSTRING(Var_Registro,1017,2),	SUBSTRING(Var_Registro,1019,1),	SUBSTRING(Var_Registro,1020,3),	SUBSTRING(Var_Registro,1023,9),
												Sta_NO_Proces,	Tip_Tarjeta );
                                        END IF;
                                END IF;

                                        IF(Tipo_Reg = Var_Trailer )
                                        THEN
											INSERT INTO TCR_HEDTRAOUT_ADM (	Hto_FolioAr,	Hto_FecRes,		Hto_Tipo,
																			Hto_Campo1,		Hto_Campo2,		Hto_Campo3,		Hto_Campo4,		Hto_Campo5,
																			Hto_Campo6,		Hto_Campo7,		Hto_Campo8,		Hto_Campo9,		Hto_Campo10,
																			Hto_Campo11,	Hto_Campo12,	Hto_Status )
													VALUES( Var_Folio,						Var_FecResp,					Tipo_Trailer,
															SUBSTRING(Var_Registro,1,7),	SUBSTRING(Var_Registro,8,3),	SUBSTRING(Var_Registro,11,5),	SUBSTRING(Var_Registro,16,4),	SUBSTRING(Var_Registro,20,2),
															SUBSTRING(Var_Registro,22,6),	SUBSTRING(Var_Registro,28,4),	SUBSTRING(Var_Registro,32,12),	SUBSTRING(Var_Registro,44,8),	SUBSTRING(Var_Registro,52,16),
															SUBSTRING(Var_Registro,68,9),	SUBSTRING(Var_Registro,77,6),	Sta_NO_Proces  );
                                        END IF;
                                        SELECT Tipo_Reg;
                            END IF;

					END;
				END LOOP;
		END;
    CLOSE Cur_ArchRespPro;
    DELETE FROM TCR_ARCHRESPPROSA_TMP;
END$$