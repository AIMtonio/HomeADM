-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TITULARESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TITULARESREP`;DELIMITER $$

CREATE PROCEDURE `TITULARESREP`(
	Par_Ident				BIGINT(20),
	Par_Tipo				INT(11),
	Par_Seccion				INT(11),
	Par_Limit				INT(11),


	Par_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11) ,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11) ,
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN

	DECLARE Cuenta_ID	 		BIGINT(12);
	DECLARE	Contador1			INT(11);
	DECLARE	Contador2			INT(11);
	DECLARE NombreGerente		VARCHAR(300);
	DECLARE PieFirmaCli			VARCHAR(100);
	DECLARE PieFirmaRep			VARCHAR(100);
	DECLARE TituloFirmaCli		VARCHAR(100);
	DECLARE TituloFirmaRep		VARCHAR(100);


	DECLARE  CuentaAhoID 		BIGINT(12);
	DECLARE  PersonaID 			INT(12);
	DECLARE  EsApoderado 		CHAR(1);
	DECLARE  EsTitular 			CHAR(1);
	DECLARE  EsCotitular 		CHAR(1);
	DECLARE  EsBeneficiario 	CHAR(1);
	DECLARE  EsProvRecurso 		CHAR(1);
	DECLARE  EsPropReal 		CHAR(1);
	DECLARE  EsFirmante 		CHAR(1);
	DECLARE  Titulo 			VARCHAR(10);
	DECLARE  PrimerNombre 		VARCHAR(50);
	DECLARE  SegundoNombre 		VARCHAR(50);
	DECLARE  TercerNombre 		VARCHAR(50);
	DECLARE  ApellidoPaterno 	VARCHAR(50);
	DECLARE  ApellidoMaterno 	VARCHAR(50);
	DECLARE  NombreCompleto 	VARCHAR(200);
	DECLARE  FechaNac 			DATE;
	DECLARE  PaisNacimiento 	INT(5);
	DECLARE  EdoNacimiento 		INT(11);
	DECLARE  EstadoCivil 		CHAR(2);
	DECLARE  Sexo 				CHAR(1);
	DECLARE  Nacionalidad 		CHAR(1);
	DECLARE  CURP 				CHAR(18);
	DECLARE  RFC 				CHAR(13);
	DECLARE  OcupacionID 		INT(5);
	DECLARE  FEA 				VARCHAR(250);
	DECLARE  PaisRFC 			INT(11);
	DECLARE  PuestoA 			VARCHAR(100);
	DECLARE  SectorGeneral 		INT(3);
	DECLARE  ActividadBancoMX 	VARCHAR(15);
	DECLARE  ActividadINEGI 	INT(5);
	DECLARE  SectorEconomico 	INT(3);
	DECLARE  TipoIdentiID 		INT(11);
	DECLARE  OtraIdentifi 		VARCHAR(20);
	DECLARE  NumIdentific 		VARCHAR(20);
	DECLARE  FecExIden 			DATE;
	DECLARE  FecVenIden 		DATE;
	DECLARE  Domicilio 			VARCHAR(200);
	DECLARE  TelefonoCasa 		VARCHAR(20);
	DECLARE  TelefonoCelular 	VARCHAR(20);
	DECLARE  Correo 			VARCHAR(50);
	DECLARE  PaisResidencia 	INT(5);
	DECLARE  DocEstanciaLegal 	VARCHAR(3);
	DECLARE  DocExisLegal 		VARCHAR(30);
	DECLARE  FechaVenEst 		DATE;
	DECLARE  NumEscPub 			VARCHAR(20);
	DECLARE  FechaEscPub 		DATE;
	DECLARE  EstadoID 			INT(11);
	DECLARE  MunicipioID 		INT(11);
	DECLARE  NotariaID 			INT(11);
	DECLARE  TitularNotaria 	VARCHAR(100);
	DECLARE  RazonSocial 		VARCHAR(150);
	DECLARE  Fax 				VARCHAR(30);
	DECLARE  ParentescoID 		INT(11);
	DECLARE  Porcentaje 		DECIMAL(12,2);
	DECLARE  ClienteID 			INT(11);
	DECLARE  ExtTelefonoPart 	VARCHAR(6);
	DECLARE  EstatusRelacion 	CHAR(1);
	DECLARE  IngresoRealoRecur 	DECIMAL(14,2);


	DECLARE Entero_Cero    		INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Tipo_Cuenta			INT(11);
	DECLARE TipoSofiFirmas		INT(11);
	DECLARE Titular_Si			CHAR(1);
	DECLARE TipoFirma_Cli		CHAR(1);
	DECLARE TipoFirma_Rep		CHAR(1);
	DECLARE VarInstitucionID    INT(5);
	DECLARE CteSofiExpress      INT(5);


	DECLARE CURSORTITULARES CURSOR FOR
		SELECT
			cp.CuentaAhoID,		cp.PersonaID, 		cp.EsApoderado, 	cp.EsTitular, 		cp.EsCotitular,
			cp.EsBeneficiario, 	cp.EsProvRecurso, 	cp.EsPropReal, 		cp.EsFirmante, 		cp.Titulo,
			cp.PrimerNombre,	cp.SegundoNombre,	cp.TercerNombre,	cp.ApellidoPaterno,	cp.ApellidoMaterno,
			cp.NombreCompleto,	cp.FechaNac,		cp.PaisNacimiento,	cp.EstadoCivil,		cp.Sexo,
			cp.Nacionalidad,	cp.CURP,			cp.RFC,				cp.PuestoA,			cp.SectorGeneral,
			cp.ActividadBancoMX,cp.ActividadINEGI,	cp.SectorEconomico,	cp.TipoIdentiID,	cp.OtraIdentifi,
			cp.NumIdentific,	cp.FecExiden,		cp.FecVenIden,		cp.Domicilio,		cp.TelefonoCasa,
			cp.TelefonoCelular,	cp.Correo,			cp.PaisResidencia,	cp.DocEstanciaLegal,cp.DocExisLegal,
			cp.FechaVenEst,		cp.NumEscPub,		cp.FechaEscPub,		cp.EstadoID,		cp.MunicipioID,
			cp.NotariaID,		cp.TitularNotaria,	cp.RazonSocial,		cp.Fax,				cp.ParentescoID,
			cp.Porcentaje,		cp.ClienteID,		cp.ExtTelefonoPart,	cp.EstatusRelacion,	cp.IngresoRealoRecur
		FROM CUENTASPERSONA cp
		WHERE 	cp.CuentaAhoID = Cuenta_ID
		AND 	cp.EsTitular = Titular_Si
        AND 	cp.EstatusRelacion = 'V'
		LIMIT PAR_LIMIT;


		SET Entero_Cero     	:= 0;
		SET Decimal_Cero		:= 0.00;
		SET Cadena_Vacia		:= '';
		SET Tipo_Cuenta			:= 1;
		SET TipoSofiFirmas		:= 2;
		SET Titular_Si			:= 'S';
		SET TipoFirma_Cli		:=	'C';
		SET TipoFirma_Rep		:=	'R';
		SET CteSofiExpress      := 61;
		CASE Par_Tipo
			WHEN Tipo_Cuenta THEN
				SET Cuenta_ID = Par_Ident;
				SELECT
					cp.CuentaAhoID,		cp.PersonaID, 		cp.EsApoderado, 	cp.EsTitular, 		cp.EsCotitular,
					cp.EsBeneficiario, 	cp.EsProvRecurso, 	cp.EsPropReal, 		cp.EsFirmante, 		cp.Titulo,
					cp.PrimerNombre,	cp.SegundoNombre,	cp.TercerNombre,	cp.ApellidoPaterno,	cp.ApellidoMaterno,
					cp.NombreCompleto,	cp.FechaNac,		cp.PaisNacimiento,	cp.EstadoCivil,		cp.Sexo,
					cp.Nacionalidad,	cp.CURP,			cp.RFC,				cp.PuestoA,			cp.SectorGeneral,
					cp.ActividadBancoMX,cp.ActividadINEGI,	cp.SectorEconomico,	cp.TipoIdentiID,	cp.OtraIdentifi,
					cp.NumIdentific,	cp.FecExiden,		cp.FecVenIden,		cp.Domicilio,		cp.TelefonoCasa,
					cp.TelefonoCelular,	cp.Correo,			cp.PaisResidencia,	cp.DocEstanciaLegal,cp.DocExisLegal,
					cp.FechaVenEst,		cp.NumEscPub,		cp.FechaEscPub,		cp.EstadoID,		cp.MunicipioID,
					cp.NotariaID,		cp.TitularNotaria,	cp.RazonSocial,		cp.Fax,				cp.ParentescoID,
					cp.Porcentaje,		cp.ClienteID,		cp.ExtTelefonoPart,	cp.EstatusRelacion,	cp.IngresoRealoRecur
				FROM CUENTASPERSONA cp
				WHERE cp.CuentaAhoID = Cuenta_ID
				AND cp.EsTitular = Titular_Si
				LIMIT PAR_LIMIT;



			WHEN TipoSofiFirmas THEN
				SET Cuenta_ID = Par_Ident;
				SET TituloFirmaCli		:= 'NOMBRE Y FIRMA DE CONFORMIDAD DEL CLIENTE';
                SET TituloFirmaRep      := 'FIRMA DEL REPRESENTANTE';
				DROP TEMPORARY TABLE IF EXISTS TITTABREP;
				CREATE TEMPORARY TABLE TITTABREP(
					Columna			INT,
					TipoFirmaIzq	CHAR(1),
					PieFirmaIzq 	VARCHAR(450),
					TituloIzq		VARCHAR(100),
					NombreIzq		VARCHAR(300),
					TipoFirmaDer	CHAR(1),
					PieFirmaDer		VARCHAR(450),
					TituloDer		VARCHAR(100),
					NombreDer		VARCHAR(300)
				);
				SET Contador1 := 1;
				SET Contador2 := 1;
				OPEN CURSORTITULARES;
					BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						LOOP
							FETCH CURSORTITULARES INTO
								CuentaAhoID,		PersonaID, 		EsApoderado, 	EsTitular, 		EsCotitular,
								EsBeneficiario, 	EsProvRecurso, 	EsPropReal, 	EsFirmante, 	Titulo,
								PrimerNombre,		SegundoNombre,	TercerNombre,	ApellidoPaterno,ApellidoMaterno,
								NombreCompleto,		FechaNac,		PaisNacimiento,	EstadoCivil,	Sexo,
								Nacionalidad,		CURP,			RFC,			PuestoA,		SectorGeneral,
								ActividadBancoMX,	ActividadINEGI,	SectorEconomico,TipoIdentiID,	OtraIdentifi,
								NumIdentific,		FecExiden,		FecVenIden,		Domicilio,		TelefonoCasa,
								TelefonoCelular,	Correo,			PaisResidencia,	DocEstanciaLegal,DocExisLegal,
								FechaVenEst,		NumEscPub,		FechaEscPub,	EstadoID,		MunicipioID,
								NotariaID,			TitularNotaria,	RazonSocial,	Fax,			ParentescoID,
								Porcentaje,			ClienteID,		ExtTelefonoPart,EstatusRelacion,IngresoRealoRecur;
								SET PieFirmaCli := CONCAT('TITULAR ',CONVPORCANT(Contador1, 'I', 0, ''),'.');
								IF(FLOOR(Contador1%2) = 1) THEN
									INSERT INTO TITTABREP VALUES(
										Contador2,
										TipoFirma_Cli,
										PieFirmaCli,
										TituloFirmaCli,
										CONCAT(	TRIM(
													CONCAT(IFNULL(PrimerNombre,Cadena_Vacia), ' ',IFNULL(SegundoNombre,Cadena_Vacia), ' ',IFNULL(TercerNombre,Cadena_Vacia))),
													' ',
													CONCAT(IFNULL(ApellidoPaterno,Cadena_Vacia), ' ',IFNULL(ApellidoMaterno,Cadena_Vacia))
												), Cadena_Vacia,	Cadena_Vacia, Cadena_Vacia, Cadena_Vacia);
								ELSE
									UPDATE TITTABREP
										SET
											TipoFirmaDer= TipoFirma_Cli,
											PieFirmaDer = PieFirmaCli,
											TituloDer	= TituloFirmaCli,
											NombreDer	=
												CONCAT(	TRIM(
													CONCAT(IFNULL(PrimerNombre,Cadena_Vacia), ' ',IFNULL(SegundoNombre,Cadena_Vacia), ' ',IFNULL(TercerNombre,Cadena_Vacia))),
													' ',
													CONCAT(IFNULL(ApellidoPaterno,Cadena_Vacia), ' ',IFNULL(ApellidoMaterno,Cadena_Vacia))
												)
									WHERE Columna = Contador2;
									SET Contador2 := Contador2 + 1;
								END IF;
								SET Contador1 := Contador1 + 1;
						END LOOP;
					END;
				CLOSE CURSORTITULARES;


			SELECT 		ins.Nombre, 	ins.InstitucionID
				INTO	PieFirmaRep, 	VarInstitucionID
				FROM PARAMETROSSIS ps,
					INSTITUCIONES ins
				WHERE ps.InstitucionID = ins.InstitucionID;

				SET VarInstitucionID = IFNULL(VarInstitucionID, Entero_Cero);


			IF(VarInstitucionID = CteSofiExpress)THEN
				 SELECT
                    CONCAT(su.TituloGte, ' ', us.NombreCompleto)
                INTO
                    NombreGerente
                FROM
                    SUCURSALES su,
                    USUARIOS us,
					CUENTASAHO cta
                WHERE su.SucursalID =   cta.SucursalID
                AND us.UsuarioID = su.NombreGerente
				AND cta.CuentaAhoID = Par_Ident;


					ELSE

					SELECT CONCAT(su.TituloGte, ' ', us.NombreCompleto) INTO NombreGerente
					FROM SUCURSALES su,
						USUARIOS us
					WHERE SucursalID =   Aud_Sucursal
					AND us.UsuarioID = su.NombreGerente;

				END IF;


				IF(FLOOR(Contador1%2) = 1) THEN
					INSERT INTO TITTABREP
						VALUES(
							Contador2,
							TipoFirma_Rep,
							PieFirmaRep,
							TituloFirmaRep,
							NombreGerente, Cadena_Vacia, Cadena_Vacia, Cadena_Vacia, Cadena_Vacia);
				ELSE
					UPDATE TITTABREP
						SET
							TipoFirmaDer= TipoFirma_Rep ,
							PieFirmaDer = PieFirmaRep,
							TituloDer	= TituloFirmaRep,
							NombreDer	= NombreGerente
					WHERE Columna = Contador2;
				END IF;
				SELECT * FROM TITTABREP;
			ELSE
				SELECT Cadena_Vacia;
				LEAVE TerminaStore;
		END CASE;

END TerminaStore$$