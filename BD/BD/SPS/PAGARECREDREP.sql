-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGARECREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGARECREDREP`;DELIMITER $$

CREATE PROCEDURE `PAGARECREDREP`(
	Par_CreditoID			BIGINT(12),			-- ID del credito
	Par_Institucion			TINYINT UNSIGNED, 	-- numero solo para relacionar la empresa en este caso orderexpress
	Par_TipoPag				TINYINT UNSIGNED, 	-- pagare tasa fija, tasa variable persona fisica persona moral
	Par_Seccion				TINYINT UNSIGNED, 	-- seccion del reporte a mostrar cabecera, cuerpo, pie, pag1 etc

    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	-- orderespress (OrderExpress)
	DECLARE DirecSucursal	VARCHAR(250);
	DECLARE LugarSucursal	VARCHAR(250);
	DECLARE NombreEmpresa	VARCHAR(250);
	DECLARE TipPagcap		VARCHAR(250);
	DECLARE Amortizacion1	INT(11);
	DECLARE Frecuencia1		VARCHAR(250);
	DECLARE Monto1			VARCHAR(250);
	DECLARE Amortizacion2	INT(11);
	DECLARE Frecuencia2		VARCHAR(250);
	DECLARE Monto2			VARCHAR(250);
    DECLARE NumSucursalCred	INT(11);
    DECLARE DirecSucCred	VARCHAR(200);
    DECLARE Var_SucursalID	INT(11);			-- Numero de sucursal del usuario que genera el pagare
    DECLARE Var_SoliCredID	INT(11);


	/*  Declaracion de Variables SECCION II  */
	DECLARE TipoAyEInd      INT(11);
	DECLARE	MontoCred		DECIMAL(12,2);
	DECLARE	MontoCredTxt	VARCHAR(200);
	DECLARE	EdoSucursal		VARCHAR(100);
	DECLARE	Var_FecExigible	DATE;
	DECLARE	Var_Frecuencia	VARCHAR(50);
	DECLARE	NombreCte		VARCHAR(250);
	DECLARE	Var_TipoPagoCap	CHAR(1);
	DECLARE Var_NumAmorti   INT(11);
	-- variables para reestructura
    DECLARE Var_FechaRegistro 	DATE;
    DECLARE TipoReestructura	CHAR(1);
	-- Declaracion de Variables Financiera Zafy

	/* Declaracion de constantes */
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Ins_OrderEx         INT(11);
	DECLARE Pag_TasaFija        INT(11);
	DECLARE Sec_Encab           INT(11);
	DECLARE Sec_avales          INT(11);
	DECLARE Sec_garnts          INT(11);
	DECLARE Sec_suscrip         INT(11);
	DECLARE DirOficial_Si		CHAR(1);
	DECLARE	Var_FecInicio		DATE;
	DECLARE Seccion_Zafy		INT(11);
	DECLARE Cons_SI				CHAR(11);
	DECLARE Cons_NO				CHAR(11);
    DECLARE Ins_SantaFe			INT(11);
	-- constante de reestructura
	DEClARE EstDesembolsado 	CHAR(1);
    DECLARE EsReestructura		CHAR(1);

	/* Declaracion Constantes SECCION II */
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Pag_Ind             INT(11);
	DECLARE Pag_Gpo             INT(11);
	DECLARE	PagoCrec			CHAR(1);		-- Pago Tipo Creciente
	DECLARE	PagoIgual			CHAR(1);		-- Pago Tipo Igual
	DECLARE	PagoLibre			CHAR(1);		-- Pago Tipo Libre
	DECLARE GpalInd             INT(11);            -- Pagare Grupal Individual
	DECLARE GpalGral            INT(11);
	DECLARE Presidente          INT(11);
	DECLARE	EstCerrado			CHAR(1);

	DECLARE Var_TasaFija		DECIMAL(12,4);
	DECLARE Var_DireccionSuc	VARCHAR(200);
	DECLARE Var_ClienteID           INT(11);
	DECLARE Var_TipoPersona         CHAR(1);

	-- Constantes Financiera Zafy
	DECLARE TxtNoAplica			VARCHAR(10);
	DECLARE FrecSemanales		CHAR(1);
	DECLARE FrecCatorcenales	CHAR(1);
	DECLARE FrecQuincenales		CHAR(1);
	DECLARE FrecMensuales		CHAR(1);
	DECLARE FrecPeriodo			CHAR(1);
	DECLARE FrecBimestrales		CHAR(1);
	DECLARE FrecTrimestrales	CHAR(1);
	DECLARE FrecTetramestrales	CHAR(1);
	DECLARE FrecSemestrales		CHAR(1);
	DECLARE FrecAnuales			CHAR(1);
	DECLARE TasaFija			CHAR(1);
	DECLARE NVeces				CHAR(1);

	DECLARE TxtSemanales		VARCHAR(20);
	DECLARE TxtCatorcenales		VARCHAR(20);
	DECLARE TxtQuincenales  	VARCHAR(20);
	DECLARE TxtMensuales		VARCHAR(20);
	DECLARE TxtPeriodo  		VARCHAR(20);
	DECLARE TxtBimestrales 		VARCHAR(20);
	DECLARE TxtTrimestrales 	VARCHAR(20);
	DECLARE TxtTetramestrales 	VARCHAR(20);
	DECLARE TxtSemestrales 		VARCHAR(20);
	DECLARE TxtAnuales			VARCHAR(20);
	DECLARE TipoPerMoral        CHAR(1);
	DEClARE EstatusAut			CHAR(1);
	DEClARE EstatusAutU			CHAR(1);

	DECLARE Var_FechaMinistrado	DATE;
	DECLARE Var_MontoCredito	DECIMAL(18,2);
	DECLARE Var_CalcInteresID	INT(11);
	DECLARE Var_CobraIVAInteres	CHAR(1);
	DECLARE Var_GrupoID			INT(11);
	DECLARE Var_CicloGrupo		INT(11);
	DECLARE Var_NombreGrupo		VARCHAR(200);
    DECLARE Var_SegStaFe		INT(11);

	DECLARE Var_IDGrup			INT(11);
    DECLARE conta				INT(11);
	/* Asignacion de constantes */
	SET Cadena_Vacia := '';
	SET Fecha_Vacia := '1900-01-01';
	SET Entero_Cero := 0;
	SET Ins_OrderEx	:= 1; 		-- institucio order express
	SET Pag_TasaFija:= 1; 		-- pagare de tasa fija
	SET Sec_Encab	:= 1; 		-- seccion del encabezado
	SET Sec_avales	:= 2; 		-- seccion del aval
	SET Sec_garnts	:= 3;
	SET Sec_suscrip	:= 4;
	SET DirOficial_Si:= 'S';
	SET EstDesembolsado :='D';
    SET EsReestructura	:= 'R';
    SET TipoReestructura := (SELECT TipoCredito from CREDITOS WHERE CreditoID=Par_CreditoID);

	SET Seccion_Zafy := 3;		-- Sección Financiera Zafy
	SET Cons_SI		:= 'S';
	SET Cons_NO		:= 'N';
	SET Var_SoliCredID := (SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID=Par_CreditoID);
	/* Asignacion Constantes SECCION II*/
	SET	TipoAyEInd		:=	2;		-- Institucion Accion y Evolucion
	SET Decimal_Cero	:=	0.0;
	SET	Pag_Ind			:=	1;		-- Pagare de Credito Individual
	SET	Pag_Gpo			:=	2;		-- Pagare de Credito Grupal
	SET	PagoCrec		:=	'C';	-- Tipo Pago Creciente
	SET	PagoIgual		:=	'I';	-- Tipo Pago Igual
	SET	PagoIgual		:=	'L';	-- Tipo Pago Libre
	SET	GpalInd			:=	1;		-- Pagare Grupal Individual
	SET	GpalGral		:=	2;		-- Pagare Grupal General
	SET	Presidente		:=	1;		-- Cargo de Presidente
	SET	EstCerrado		:=	'C';	-- Grupo en Estatus Cerrado

	-- Asignacion de Constantes Financiera Zafy
	SET TxtNoAplica			:= 'No Aplica';
	SET FrecSemanales		:= 'S';
	SET FrecCatorcenales	:= 'C';
	SET FrecQuincenales		:= 'Q';
	SET FrecMensuales		:= 'M';
	SET FrecPeriodo			:= 'P';
	SET FrecBimestrales		:= 'B';
	SET FrecTrimestrales	:= 'T';
	SET FrecTetramestrales	:= 'R';
	SET FrecSemestrales		:= 'E';
	SET FrecAnuales			:= 'A';

	SET TxtSemanales		:= 'Semanal';
	SET TxtCatorcenales		:= 'Catorcenal';
	SET TxtQuincenales  	:= 'Quincenal';
	SET TxtMensuales		:= 'Mensual';
	SET TxtPeriodo  		:= 'Periodo';
	SET TxtBimestrales 		:= 'Bimestral';
	SET TxtTrimestrales 	:= 'Trimestral';
	SET TxtTetramestrales 	:= 'TetraMestral';
	SET TxtSemestrales 		:= 'Semestral';
	SET TxtAnuales			:= 'Anual';
	SET	TasaFija			:= 'T';
	SET NVeces				:= 'N';
	SET TipoPerMoral        := 'M';
    SET Ins_SantaFe			:= 29;
	SET EstatusAut			:= 'A';
	SET EstatusAutU			:= 'U';
    SET Var_SegStaFe		:= 4;

	SET Aud_FechaActual := (SELECT FechaActual FROM PARAMETROSSIS LIMIT 1);


	IF(Par_Institucion = Ins_OrderEx)THEN
		IF(Par_TipoPag = Pag_TasaFija)THEN

			SET Var_ClienteID := (SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
			SET Var_TipoPersona := (SELECT TipoPersona  FROM CLIENTES WHERE ClienteID = Var_ClienteID);

			IF(Par_Seccion = Sec_Encab)THEN
				SET NombreEmpresa := (
					SELECT ins.Nombre
					FROM
						PARAMETROSSIS ps,
						INSTITUCIONES ins
					WHERE
						ps.InstitucionID = ins.InstitucionID
					LIMIT 1
				);
				SELECT
					su.SucursalID, DirecCompleta, CONCAT(mr.Nombre,', ',er.Nombre ), DATE(FechaSucursal)
				INTO
					Var_SucursalID, DirecSucursal, LugarSucursal, Aud_FechaActual
				FROM
					USUARIOS us
				LEFT OUTER JOIN SUCURSALES su ON us.SucursalUsuario = su.SucursalID
				LEFT OUTER JOIN ESTADOSREPUB er ON er.EstadoID = su.EstadoID
				LEFT OUTER JOIN MUNICIPIOSREPUB mr 	ON 	mr.EstadoID = su.EstadoID
													AND	mr.MunicipioID = su.MunicipioID
				WHERE us.UsuarioID = Aud_Usuario;

				SELECT
					cr.NumAmortizacion,
					CASE
						WHEN cr.FrecuenciaCap = 'S' THEN 'Semanales'
						WHEN cr.FrecuenciaCap = 'C' THEN 'Catorcenales'
						WHEN cr.FrecuenciaCap = 'Q' THEN 'Quincenales'
						WHEN cr.FrecuenciaCap = 'M' THEN 'Mensuales'
						WHEN cr.FrecuenciaCap = 'P' THEN 'Periodo'
						WHEN cr.FrecuenciaCap = 'B' THEN 'Bimestrales'
						WHEN cr.FrecuenciaCap = 'T' THEN 'Trimestrales'
						WHEN cr.FrecuenciaCap = 'R' THEN 'TetraMestrales'
						WHEN cr.FrecuenciaCap = 'E' THEN 'Semestrales'
						WHEN cr.FrecuenciaCap = 'A' THEN 'Anuales'
						ELSE 'No aplica'
					END ,
					CONCAT('$',FORMAT(cr.MontoCuota,2)) ,
					TipoPagocapital, FechaInicio,	cr.SucursalID
				INTO
					Amortizacion1, Frecuencia1, Monto1, TipPagcap, Var_FecInicio,
                    NumSucursalCred
				FROM CREDITOS cr
				WHERE
					cr.CreditoID = Par_CreditoID
					;
				IF(TipoReestructura = EsReestructura) THEN

                    SELECT FechaRegistro  INTO Var_FechaRegistro
					FROM REESTRUCCREDITO Res,
						CREDITOS Cre
					WHERE Res.CreditoOrigenID= Par_CreditoID
					AND Res.CreditoDestinoID = Par_CreditoID
					AND Cre.CreditoID = Res.CreditoDestinoID
					AND Res.EstatusReest = EstDesembolsado
					AND Res.Origen= EsReestructura;

                    SELECT COUNT(Amo.CreditoID) INTO Amortizacion1
					FROM SOLICITUDCREDITO Sol
					INNER JOIN CREDITOS Cre
						ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
					AND Sol.Estatus= EstDesembolsado
					AND Sol.TipoCredito= EsReestructura
					INNER JOIN REESTRUCCREDITO Res
						ON Res.CreditoOrigenID = Cre.CreditoID
					AND Res.CreditoDestinoID = Cre.CreditoID
					AND Cre.TipoCredito = EsReestructura
					INNER JOIN AMORTICREDITO Amo
						ON Amo.CreditoID = Cre.CreditoID
					WHERE Amo.CreditoID = Par_CreditoID
					AND (Amo.FechaLiquida > Var_FechaRegistro
						OR Amo.FechaLiquida = Fecha_Vacia);

                END IF;


				SET DirecSucCred := DirecSucursal;
                SET DirecSucCred := FNCAPITALIZAPALABRA(DirecSucCred);
                SET DirecSucCred := (IFNULL(DirecSucCred, Cadena_Vacia));
                SET DirecSucCred := REPLACE(DirecSucCred, ' De ', ' de ');
                SET DirecSucCred := REPLACE(DirecSucCred, ' Del ', ' del ');
                SET DirecSucCred := REPLACE(DirecSucCred, ' La ', ' la ');


				SELECT
					NombreEmpresa, 		cl.ClienteID,  		DATE(cr.FechaVencimien) AS FechaVencimien,
					cr.CreditoID, 	CONCAT('$',FORMAT(cr.MontoCredito,2)) AS MontoCredito,
					CONVPORCANT(cr.MontoCredito, '$', 'Peso', 'Nacional') AS MontoLetra,
					CONCAT(cr.TasaFija,'%') AS TasaFija, Amortizacion1, Frecuencia1, Monto1,
					DirecSucursal, 		CONCAT(cr.PeriodicidadCap,' dias ') AS PeriodicidadCap ,
					CONCAT(
						CASE
							WHEN cr.TipCobComMorato = 'N' THEN ROUND( cr.FactorMora * cr.TasaFija, 2)
							WHEN cr.TipCobComMorato = 'T' THEN cr.FactorMora
							ELSE 'No aplica'
						END , '%') AS IntMora,
					LugarSucursal, 		FORMATEAFECHACONTRATO(Aud_FechaActual) AS Aud_FechaActual,
					CASE WHEN Var_TipoPersona = TipoPerMoral THEN
					cl.RazonSocial
					ELSE
					CONCAT(IFNULL(cl.ApellidoPaterno,Cadena_Vacia),' ',IFNULL(cl.ApellidoMaterno,Cadena_Vacia),' ',IFNULL(cl.PrimerNombre,Cadena_Vacia),' ',IFNULL(cl.SegundoNombre,Cadena_Vacia),' ',IFNULL(cl.TercerNombre,Cadena_Vacia))
					END AS NombreCliente,
					dc.DireccionCompleta AS DireccionCte,
					Amortizacion2, Frecuencia2, Monto2,FORMATEAFECHACONTRATO( DATE(cr.FechaVencimien)) AS FechaVencTxt,
					Var_FecInicio, cl.TipoPersona,	DirecSucCred, Var_SucursalID
				FROM
					CREDITOS cr
				LEFT OUTER JOIN CLIENTES cl 		ON cr.ClienteID = cl.ClienteID
				LEFT OUTER JOIN DIRECCLIENTE dc 	ON cr.ClienteID = dc.ClienteID
													AND dc.Oficial = DirOficial_Si
				LEFT OUTER JOIN PRODUCTOSCREDITO pc	ON cr.ProductoCreditoID = pc.ProducCreditoID
				WHERE
					cr.CreditoID = Par_CreditoID;

			END IF;

			-- SECCION AVALES
			IF(Par_Seccion = Sec_avales) THEN

				DROP TABLE IF EXISTS TEMP_AVALES;
				CREATE TEMPORARY TABLE TEMP_AVALES(
					aval	  		VARCHAR(300),
					direcAval	 	VARCHAR(500),
					RFC			 	VARCHAR(20),
					Fila		 	INT(11),
					FilaRom		 	VARCHAR(10),
					TipoPersona 	CHAR(1),
					ClienteID		INT(11),
					NombreRepresen  VARCHAR(300),
					KEY(ClienteID)
				);

				SET @rowcount := 0;

				-- INSERTA AVALES QUE SON CLIENTES
				INSERT INTO TEMP_AVALES(
				SELECT Cli.NombreCompleto,Dir.DireccionCompleta, CASE WHEN Cli.TipoPersona = 'M' THEN RFCpm ELSE RFC END,
						@rowcount := @rowcount +1, CONVNUMROM(@rowcount), Cli.TipoPersona, IFNULL(Avs.ClienteID,Entero_Cero),
						Cadena_Vacia
				FROM AVALESPORSOLICI Avs
				INNER JOIN SOLICITUDCREDITO Sol
					ON Avs.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN CLIENTES Cli
					ON Cli.ClienteID = Avs.ClienteID
				INNER JOIN DIRECCLIENTE Dir
					ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial = DirOficial_Si
				WHERE  Sol.CreditoID = Par_CreditoID
					AND Avs.SolicitudCreditoID = Var_SoliCredID);

				-- INSERTA AVALES QUE SON PROSPECTOS
				INSERT INTO TEMP_AVALES(
				SELECT Pro.NombreCompleto,CONCAT(
											IFNULL(Pro.Calle,''),', NO. ',
											IFNULL(Pro.NumExterior,''),', INTERIOR ',
											IFNULL(Pro.NumInterior,''),', COL. ',
											IFNULL(Pro.Colonia,''),' C.P. ',
											IFNULL(Pro.CP,''),', ',
											IFNULL(Mun.Nombre,''), ', ',
											IFNULL(Edo.Nombre,'')),
						CASE WHEN Pro.TipoPersona = 'M' THEN Pro.RFCpm ELSE Pro.RFC END,
						@rowcount := @rowcount +1, CONVNUMROM(@rowcount), Pro.TipoPersona, IFNULL(Avs.ClienteID,Entero_Cero),
						Cadena_Vacia
				FROM AVALESPORSOLICI Avs
				INNER JOIN SOLICITUDCREDITO Sol
					ON Avs.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN PROSPECTOS Pro
					ON Avs.ProspectoID = Pro.ProspectoID
				INNER JOIN ESTADOSREPUB Edo
					ON Pro.EstadoID = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun
					ON Pro.EstadoID = Mun.EstadoID AND Pro.MunicipioID = Mun.MunicipioID
				WHERE  Sol.CreditoID = Par_CreditoID
					AND Avs.SolicitudCreditoID = Var_SoliCredID
                    AND Avs.ClienteID = Entero_Cero);

				-- INSERTA AVALES QUE SON SOLO AVALES
				INSERT INTO TEMP_AVALES(
				SELECT Ava.NombreCompleto,Ava.DireccionCompleta, CASE WHEN Ava.TipoPersona = 'M' THEN RFCpm ELSE RFC END,
						@rowcount := @rowcount +1, CONVNUMROM(@rowcount), Ava.TipoPersona, Entero_Cero,
						Cadena_Vacia
				FROM AVALESPORSOLICI Avs
				INNER JOIN SOLICITUDCREDITO Sol
					ON Avs.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN AVALES Ava
					ON Ava.AvalID = Avs.AvalID
				WHERE  Sol.CreditoID = Par_CreditoID
					AND Avs.SolicitudCreditoID = Var_SoliCredID);

				-- ACTUALIZA DATOS DEL REPRESENTANTE LEGAL SI ES PERSONA MORAL
				UPDATE TEMP_AVALES tmp
					LEFT JOIN CUENTASAHO cta
						ON tmp.ClienteID = cta.ClienteID
							AND cta.EsPrincipal = Cons_SI
					LEFT JOIN CUENTASPERSONA per
						ON cta.CuentaAhoID = per.CuentaAhoID
							AND per.EsApoderado = Cons_SI
				SET tmp.NombreRepresen = per.NombreCompleto
				WHERE  tmp.ClienteID > Entero_Cero
					AND tmp.TipoPersona = 'M';

				SELECT aval, direcAval, RFC, Fila, FilaRom, TipoPersona, NombreRepresen
					FROM TEMP_AVALES;

			END IF;-- FIN SECCION AVALES

			-- SECCION GARANTES
			IF(Par_Seccion = Sec_garnts) THEN

				DROP TABLE IF EXISTS TEMP_GARANTES;
				CREATE TEMPORARY TABLE TEMP_GARANTES(
					Garante  		VARCHAR(300),
					DirecGarante 	VARCHAR(300),
					TipoPersona 	CHAR(1),
					ClienteID		INT(11),
					NombreRepresen  VARCHAR(300),
					KEY(ClienteID)
				);

				-- INSERTA GARANTES QUE SON CLIENTES
				INSERT INTO TEMP_GARANTES(
				SELECT Cli.NombreCompleto,Dir.DireccionCompleta, Cli.TipoPersona, IFNULL(Gar.ClienteID,Entero_Cero),
						Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Gar.ClienteID
				INNER JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID
					AND Dir.Oficial = DirOficial_Si
				WHERE Sol.CreditoID = Par_CreditoID);


				-- INSERTA GARANTES QUE SON AVALES
				INSERT INTO TEMP_GARANTES(
				SELECT Ava.NombreCompleto,CONCAT(
											IFNULL(Ava.Calle,''), ' ',
											IFNULL(Ava.NumExterior,''), ', COL. ',
											IFNULL(Ava.Colonia,''), ' CP. ',
											IFNULL(Ava.CP,''),' ,',
											IFNULL(Mun.Nombre,''), ' ,',
											IFNULL(Edo.Nombre,'')),
											Ava.TipoPersona, Entero_Cero,Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				INNER JOIN AVALES Ava ON Ava.AvalID = Gar.AvalID
				INNER JOIN ESTADOSREPUB Edo ON Ava.EstadoID = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Ava.EstadoID = Mun.EstadoID
					AND Ava.MunicipioID = Mun.MunicipioID
				WHERE Sol.CreditoID = Par_CreditoID);


				-- GARANTES QUE SON PROSPECTOS
				INSERT INTO TEMP_GARANTES(
				SELECT Pro.NombreCompleto,CONCAT(
											IFNULL(Pro.Calle,''),', NO. ',
											IFNULL(Pro.NumExterior,''),', INTERIOR ',
											IFNULL(Pro.NumInterior,''),', COL. ',
											IFNULL(Pro.Colonia,''),' C.P. ',
											IFNULL(Pro.CP,''),', ',
											IFNULL(Mun.Nombre,''), ', ',
											IFNULL(Edo.Nombre,'')),
											Pro.TipoPersona,IFNULL(Pro.ClienteID,Entero_Cero),Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				INNER JOIN PROSPECTOS Pro ON Gar.ProspectoID = Pro.ProspectoID AND Gar.ClienteID = Entero_Cero
				INNER JOIN ESTADOSREPUB Edo ON Pro.EstadoID = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Pro.EstadoID = Mun.EstadoID
					AND Pro.MunicipioID = Mun.MunicipioID
				WHERE Sol.CreditoID = Par_CreditoID);

				-- GARANTES QUE NO SON CLIENTE NI PROPSECTOS
				INSERT INTO TEMP_GARANTES(
				SELECT Gar.GaranteNombre,CONCAT(
											IFNULL(Gar.CalleGarante,''),', NO. ',
											IFNULL(Gar.NumExtGarante,''),', INTERIOR ',
											IFNULL(Gar.NumIntGarante,''),', COL. ',
											IFNULL(Gar.ColoniaGarante,''),' C.P. ',
											IFNULL(Gar.CodPostalGarante,''),', ',
											IFNULL(Mun.Nombre,''), ', ',
											IFNULL(Edo.Nombre,'')),
											"F",Entero_Cero,Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				AND Gar.ClienteID = Entero_Cero AND Gar.AvalID = Entero_Cero
					AND Gar.ProspectoID = Entero_Cero
				INNER JOIN ESTADOSREPUB Edo ON Gar.EstadoIDGarante = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Gar.EstadoIDGarante = Mun.EstadoID
					AND Gar.MunicipioGarante = Mun.MunicipioID
				WHERE Sol.CreditoID = Par_CreditoID);

				-- ACTUALIZA DATOS DEL REPRESENTA LEGAL SI ES PERSONA MORAL
				UPDATE TEMP_GARANTES tmp
					LEFT JOIN CUENTASAHO cta
						ON tmp.ClienteID = cta.ClienteID
							AND cta.EsPrincipal = Cons_SI
					LEFT JOIN CUENTASPERSONA per
						ON cta.CuentaAhoID = per.CuentaAhoID
							AND per.EsApoderado = Cons_SI
				SET tmp.NombreRepresen = per.NombreCompleto
				WHERE  tmp.ClienteID > Entero_Cero
					AND tmp.TipoPersona = 'M';

				SELECT 	Garante AS garante,	DirecGarante AS direcGarante, TipoPersona,	NombreRepresen
				FROM TEMP_GARANTES tmp;

			END IF;-- FIN SECCION GARANTES

			-- SECCION SUSCRIPTORES
			IF(Par_Seccion = Sec_suscrip)THEN
				SELECT
					cl.RazonSocial, IFNULL(cp.NombreCompleto,Cadena_Vacia) AS NombreApoderado,
					CONCAT(IFNULL(cl.ApellidoPaterno,Cadena_Vacia),' ',IFNULL(cl.ApellidoMaterno,Cadena_Vacia),' ',IFNULL(cl.PrimerNombre,Cadena_Vacia),' ',IFNULL(cl.SegundoNombre,Cadena_Vacia),' ',IFNULL(cl.TercerNombre,Cadena_Vacia))
					AS NombreCliente,
					dc.DireccionCompleta AS DireccionCte
				FROM
					CREDITOS cr
				LEFT OUTER JOIN CLIENTES cl
					ON cr.ClienteID = cl.ClienteID
				LEFT OUTER JOIN DIRECCLIENTE dc
					ON cr.ClienteID = dc.ClienteID AND dc.Oficial = DirOficial_Si
				LEFT OUTER JOIN CUENTASPERSONA cp
					ON cr.CuentaID = cp.CuentaAhoID AND cp.EsApoderado = Cons_SI
				WHERE cr.CreditoID = Par_CreditoID LIMIT 1;

			END IF;-- FIN SECCION SUCRIPTORES



		END IF;
	END IF;

	/* *********** SECCION II: PAGARE DE CREDITO ACCION Y EVOLUCION *********** */
	IF (Par_Institucion	=	TipoAyEInd)	THEN

			SELECT Est.Nombre,CONCAT(Mun.Nombre,', ',Est.Nombre)
						INTO EdoSucursal,Var_DireccionSuc
			FROM SUCURSALES Suc
				INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID AND Suc.MunicipioID = Mun.MunicipioID
					INNER JOIN SOLICITUDCREDITO Sol ON Suc.SucursalID =Sol.SucursalID
			WHERE Sol.CreditoID =Par_CreditoID;


		IF( Par_TipoPag = Pag_Ind OR Par_Seccion = GpalInd)	THEN -- Pagare Individual
			SELECT	Cre.MontoCredito,	Cre.FechaVencimien,	Cre.FrecuenciaCap,	Cli.NombreCompleto,	Cre.TipoPagoCapital,
					Cre.NumAmortizacion,Cre.TasaFija
			INTO	MontoCred,			Var_FecExigible,		Var_Frecuencia,		NombreCte,			Var_TipoPagoCap,
					Var_NumAmorti,		Var_TasaFija
			FROM	CREDITOS	Cre,
					CLIENTES Cli
			WHERE	Cre.CreditoID	=	Par_CreditoID
				AND	Cre.ClienteID	=	Cli.ClienteID;

			SET	MontoCredTxt	:=	CONVPORCANT(MontoCred,'$L','Peso','Nacional');

			IF(Var_TipoPagoCap = PagoLibre)THEN
				SELECT  CONCAT(CONVERT(Var_NumAmorti,CHAR),' ',
						CASE
							WHEN Var_NumAmorti ='1' THEN 'Amortizacion Libre'
							ELSE 'Amortizaciones Libres'
						END ) INTO Var_Frecuencia;
			ELSE
				SELECT  CASE
							WHEN Var_Frecuencia ='S' THEN 'Semanal'
							WHEN Var_Frecuencia ='C' THEN 'Catorcenal'
							WHEN Var_Frecuencia ='Q' THEN 'Quincenal'
							WHEN Var_Frecuencia ='M' THEN 'Mensual'
							WHEN Var_Frecuencia ='P' THEN 'Periodica'
							WHEN Var_Frecuencia ='B' THEN 'Bimestral'
							WHEN Var_Frecuencia ='T' THEN 'Trimestral'
							WHEN Var_Frecuencia ='R' THEN 'Tetramestral'
							WHEN Var_Frecuencia ='E' THEN 'Semestral'
							WHEN Var_Frecuencia ='A' THEN 'Anual'
							WHEN Var_Frecuencia ='L' THEN 'Libre'
						END INTO Var_Frecuencia;
			END IF;

			SELECT	MontoCred,		MontoCredTxt,	EdoSucursal,	FORMATEAFECHACONTRATO(Var_FecExigible) AS Var_FecExigible,
					Var_Frecuencia,	NombreCte,		FORMATEAFECHACONTRATO(Aud_FechaActual) AS Var_FechaActual,Var_TasaFija,
					Var_DireccionSuc;
		ELSE	-- Pagare Grupal
			IF(Par_Seccion = GpalGral) THEN

		SELECT Est.Nombre,CONCAT(Mun.Nombre,', ',Est.Nombre)

	-- Para los creditos grupales se toma la sucursal del grupo
						INTO EdoSucursal,Var_DireccionSuc
			FROM SUCURSALES Suc
				INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID AND Suc.MunicipioID = Mun.MunicipioID
					INNER JOIN GRUPOSCREDITO Sol ON Suc.SucursalID =Sol.SucursalID
			WHERE Sol.GrupoID =Par_CreditoID; -- El Parametro Par Credito esta mandando el numero del Grupo


				SELECT	Cre.FechaVencimien,	Cre.FrecuenciaCap,	Cli.NombreCompleto,	Cre.TipoPagoCapital,
						Cre.NumAmortizacion,Cre.TasaFija
				INTO	Var_FecExigible,		Var_Frecuencia,		NombreCte,			Var_TipoPagoCap,
						Var_NumAmorti,			Var_TasaFija
				FROM	CREDITOS			Cre,
						SOLICITUDCREDITO 	Sol,
						INTEGRAGRUPOSCRE 	Igr,
						GRUPOSCREDITO		Gru,
						CLIENTES			Cli
				WHERE	Gru.GrupoID				=	Igr.GrupoID
					AND Igr.GrupoID				=	Par_CreditoID
					AND Igr.Cargo				=	Presidente
					AND Cre.SolicitudCreditoID	=	Igr.SolicitudCreditoID
					AND Igr.SolicitudCreditoID	=	Sol.SolicitudCreditoID
					AND Gru.EstatusCiclo		=	EstCerrado
					AND	Cli.ClienteID			=	Cre.ClienteID;

				SELECT	SUM(Cre.MontoCredito)
				INTO	MontoCred
				FROM	CREDITOS Cre
				WHERE	Cre.GrupoID	=	Par_CreditoID;

				SET	MontoCredTxt	:=	CONVPORCANT(MontoCred,'$L','Peso','Nacional');



				IF(Var_TipoPagoCap = PagoLibre)THEN
					SELECT  CONCAT(CONVERT(Var_NumAmorti,CHAR),' ',
							CASE
								WHEN Var_NumAmorti ='1' THEN 'Amortizacion Libre'
								ELSE 'Amortizaciones Libres'
							END ) INTO Var_Frecuencia;
				ELSE
					SELECT  CASE
								WHEN Var_Frecuencia ='S' THEN 'Semanal'
								WHEN Var_Frecuencia ='C' THEN 'Catorcenal'
								WHEN Var_Frecuencia ='Q' THEN 'Quincenal'
								WHEN Var_Frecuencia ='M' THEN 'Mensual'
								WHEN Var_Frecuencia ='P' THEN 'Periodica'
								WHEN Var_Frecuencia ='B' THEN 'Bimestral'
								WHEN Var_Frecuencia ='T' THEN 'Trimestral'
								WHEN Var_Frecuencia ='R' THEN 'Tetramestral'
								WHEN Var_Frecuencia ='E' THEN 'Semestral'
								WHEN Var_Frecuencia ='A' THEN 'Anual'
								WHEN Var_Frecuencia ='L' THEN 'Libre'
							END INTO Var_Frecuencia;
				END IF;

				SELECT	MontoCred,		MontoCredTxt,	EdoSucursal,	FORMATEAFECHACONTRATO(Var_FecExigible) AS Var_FecExigible,
						Var_Frecuencia,	NombreCte,		FORMATEAFECHACONTRATO(Aud_FechaActual) AS Var_FechaActual,Var_TasaFija,
						Var_DireccionSuc;
			END IF;
		END IF;
	END IF;

	-- Sección Pagare Tasa Fija Financiera Zafy

	IF(Par_Institucion = Seccion_Zafy)THEN
		IF(Par_TipoPag = Pag_TasaFija)THEN
			IF(Par_Seccion = Sec_Encab)THEN
				DROP TEMPORARY TABLE IF EXISTS TMPDATOSINSTIT;
					CREATE TEMPORARY TABLE TMPDATOSINSTIT (
						InstitucionID		INT(11),      	-- ID del la Institucion
						NombreInstitucion	VARCHAR(100),	-- Nombre de la Institución
						DirFiscalInstit		VARCHAR(250),	-- Direccion Fiscal de la Institucion
						EstadoID			VARCHAR(50),	-- ID del Estado
						NomEstadoInstit		VARCHAR(100),	-- Nombre del Estado
						MunicipioID			VARCHAR(50), 	-- ID del Municipio
						NomMunicipioInstit	VARCHAR(150)	-- Nombre Municipio
					  );
					INSERT INTO TMPDATOSINSTIT(InstitucionID, 	NombreInstitucion,	DirFiscalInstit, EstadoID, MunicipioID)
							SELECT ins.InstitucionID,	ins.Nombre,	ins.DirFiscal,	ins.EstadoEmpresa,	ins.MunicipioEmpresa
								FROM PARAMETROSSIS ps,
									INSTITUCIONES ins
								WHERE ps.InstitucionID = ins.InstitucionID
								LIMIT 1;
						-- ESTADO RESIDENCIA
						UPDATE  TMPDATOSINSTIT T,
								ESTADOSREPUB E
						SET		T.NomEstadoInstit=E.Nombre
						WHERE	T.EstadoID=E.EstadoID;

							-- MUNICIPIO RESIDENCIA
						UPDATE  TMPDATOSINSTIT T,
								MUNICIPIOSREPUB M
						SET		T.NomMunicipioInstit=M.Nombre
						WHERE 	T.MunicipioID=M.MunicipioID
							AND T.EstadoID=M.EstadoID;


				SELECT	cr.NumAmortizacion,
					CASE
						WHEN cr.FrecuenciaCap = FrecSemanales THEN TxtSemanales
						WHEN cr.FrecuenciaCap = FrecCatorcenales THEN TxtCatorcenales
						WHEN cr.FrecuenciaCap = FrecQuincenales THEN TxtQuincenales
						WHEN cr.FrecuenciaCap = FrecMensuales THEN TxtMensuales
						WHEN cr.FrecuenciaCap = FrecPeriodo THEN TxtPeriodo
						WHEN cr.FrecuenciaCap = FrecBimestrales THEN TxtBimestrales
						WHEN cr.FrecuenciaCap = FrecTrimestrales THEN TxtTrimestrales
						WHEN cr.FrecuenciaCap = FrecTetramestrales THEN TxtTetramestrales
						WHEN cr.FrecuenciaCap = FrecSemestrales THEN TxtSemestrales
						WHEN cr.FrecuenciaCap = FrecAnuales THEN TxtAnuales
						ELSE TxtNoAplica
					END ,
					CONCAT('$ ',FORMAT(cr.MontoCuota,2)), FechaInicio
				INTO
					Amortizacion1, Frecuencia1, Monto1, Var_FecInicio
				FROM CREDITOS cr
				WHERE
					cr.CreditoID = Par_CreditoID;

                    IF(Monto1 = Entero_Cero) THEN

                     SET Monto1 =( SELECT SUM(Capital + Interes + IVAInteres) FROM AMORTICREDITO cr
									WHERE cr.CreditoID = Par_CreditoID
										GROUP BY AmortizacionID LIMIT 1);
                    END IF;



				SELECT  T1.InstitucionID,	T1.NombreInstitucion,	T1.DirFiscalInstit,	T1.NomEstadoInstit,	T1.NomMunicipioInstit,
					cl.ClienteID,
					DATE_FORMAT(cr.FechaVencimien,'%d/%m/%Y') AS FechaVencimien,
					cr.CreditoID,
					CONCAT('$ ',FORMAT(cr.MontoCredito,2)) AS MontoCredito,
					CONVPORCANT(cr.MontoCredito, '$ ', 'Peso', 'N.') AS MontoLetra,
					CONCAT(ROUND((cr.TasaFija/12),2),'%') AS TasaFijaMens, Amortizacion1, Frecuencia1, Monto1,
					CONVPORCANT((CASE
							WHEN cr.TipCobComMorato = NVeces THEN ROUND( (cr.FactorMora * cr.TasaFija)/12, 2)
							WHEN cr.TipCobComMorato = TasaFija THEN ROUND((cr.FactorMora/12),2)
							ELSE TxtNoAplica
						END),'%','2','') AS IntMora,
					FORMATEAFECHACONTRATO(Aud_FechaActual) AS Aud_FechaActual,
					IFNULL(cl.NombreCompleto,Cadena_Vacia) AS NombreCliente,
					dc.DireccionCompleta AS DireccionCte, cl.Telefono AS TelCliente,
					DATE(Var_FecInicio) AS Var_FecInicio

				FROM
					TMPDATOSINSTIT T1,CREDITOS cr
				LEFT OUTER JOIN CLIENTES cl         ON cr.ClienteID = cl.ClienteID
				LEFT OUTER JOIN DIRECCLIENTE dc     ON cr.ClienteID = dc.ClienteID
													AND dc.Oficial = DirOficial_Si
				LEFT OUTER JOIN PRODUCTOSCREDITO pc ON cr.ProductoCreditoID = pc.ProducCreditoID
				WHERE
					cr.CreditoID = Par_CreditoID;

			END IF;
					IF(Par_Seccion = Sec_avales) THEN
				SET @rowcount := 0;
				SELECT
					@rowcount := @rowcount +1 AS Fila,
					(CASE
						WHEN Avs.ClienteID  != Entero_Cero THEN (SELECT NombreCompleto FROM CLIENTES    WHERE ClienteID     = Avs.ClienteID)
						WHEN Avs.ProspectoID!= Entero_Cero THEN (SELECT NombreCompleto FROM PROSPECTOS  WHERE ProspectoID   = Avs.ProspectoID)
						WHEN Avs.AvalID     != Entero_Cero THEN (SELECT NombreCompleto FROM AVALES      WHERE AvalID        = Avs.AvalID)
					END) AS aval,
					(CASE
						WHEN Avs.ClienteID  != Entero_Cero THEN (SELECT Telefono FROM CLIENTES    WHERE ClienteID     = Avs.ClienteID)
						WHEN Avs.ProspectoID!= Entero_Cero THEN (SELECT Telefono FROM PROSPECTOS  WHERE ProspectoID   = Avs.ProspectoID)
						WHEN Avs.AvalID     != Entero_Cero THEN (SELECT Telefono FROM AVALES      WHERE AvalID        = Avs.AvalID)
					END) AS TelefonoAval,
					(CASE
						WHEN Avs.ClienteID  != Entero_Cero THEN (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID=Avs.ClienteID  AND Oficial= DirOficial_Si)
						WHEN Avs.ProspectoID!= Entero_Cero THEN
							(   SELECT CONCAT(Pro.Calle,', NO. ',Pro.NumExterior,', INTERIOR ',Pro.NumInterior,',  ', Pro.Colonia,' C.P. ',Pro.CP,', ', Mun.Nombre, ', ',Est.Nombre)
								FROM
									PROSPECTOS Pro,
									ESTADOSREPUB        Est,
									MUNICIPIOSREPUB     Mun
								WHERE
									Pro.ProspectoID = Avs.ProspectoID
								AND Pro.EstadoID        = Est.EstadoID
								AND Est.EstadoID        = Mun.EstadoID
								AND Mun.MunicipioID     = Pro.MunicipioID )
						WHEN Avs.AvalID != Entero_Cero THEN
							(   SELECT  DireccionCompleta
								FROM
									AVALES Ava,
									ESTADOSREPUB        Est,
									MUNICIPIOSREPUB     Mun
								WHERE
									Ava.AvalID = Avs.AvalID
								AND Ava.EstadoID        = Est.EstadoID
								AND Est.EstadoID        = Mun.EstadoID
								AND Mun.MunicipioID     = Ava.MunicipioID )
						END)AS direcAval,
					(CASE
						WHEN Avs.ClienteID  != Entero_Cero THEN (SELECT IF(TipoPersona = 'M', RFCpm, RFC)   FROM CLIENTES   WHERE ClienteID     = Avs.ClienteID)
						WHEN Avs.ProspectoID!= Entero_Cero THEN (SELECT IF(TipoPersona = 'M', RFCpm, RFC)   FROM PROSPECTOS WHERE ProspectoID   = Avs.ProspectoID)
						WHEN Avs.AvalID     != Entero_Cero THEN (SELECT IF(TipoPersona = 'M', RFCpm, RFC)   FROM AVALES     WHERE AvalID        = Avs.AvalID)
					END) AS RFC
				FROM
					AVALESPORSOLICI Avs,
					SOLICITUDCREDITO    Sol
				WHERE  Sol.CreditoID = Par_CreditoID
				AND Avs.SolicitudCreditoID = Sol.SolicitudCreditoID;
			END IF;
		END IF;
	END IF;


	IF(Par_Institucion = Ins_SantaFe)THEN
			SET Var_ClienteID	:= (SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
			SET Var_TipoPersona	:= (SELECT TipoPersona  FROM CLIENTES WHERE ClienteID = Var_ClienteID);
            SET Var_IDGrup := (SELECT GrupoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);


			IF(Par_Seccion = Sec_Encab)THEN
				SELECT
					su.SucursalID, su.DirecCompleta, UPPER(CONCAT(mr.Nombre,', ',er.Nombre)), DATE(su.FechaSucursal)
				INTO
					Var_SucursalID, DirecSucursal, LugarSucursal, Aud_FechaActual
				FROM SUCURSALES su
					LEFT OUTER JOIN ESTADOSREPUB er ON er.EstadoID = su.EstadoID
					LEFT OUTER JOIN MUNICIPIOSREPUB mr ON mr.EstadoID = su.EstadoID
													AND mr.MunicipioID = su.MunicipioID
				WHERE su.TipoSucursal='C' LIMIT 1;

				IF(Par_TipoPag = Var_SegStaFe) THEN
					SELECT	SUM(C.MontoCredito)
                    INTO Var_MontoCredito
					FROM CREDITOS C
						INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
						INNER JOIN INTEGRAGRUPOSCRE G on C.SolicitudCreditoID = G.SolicitudCreditoID
						INNER JOIN CLIENTES CTE ON G.ClienteID = CTE.ClienteID
						WHERE G.GrupoID = Var_IDGrup
							AND G.Estatus = EstatusAut
						ORDER BY G.Cargo;

					SELECT C.FechaMinistrado,	C.CalcInteresID,		P.CobraIVAInteres,		C.TasaFija
					INTO
						Var_FechaMinistrado,	Var_CalcInteresID,		Var_CobraIVAInteres,	Var_TasaFija
					FROM CREDITOS C
						INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID = P.ProducCreditoID
						WHERE C.CreditoID = Par_CreditoID;
                ELSE
					SELECT
						C.FechaMinistrado,		C.MontoCredito,		C.CalcInteresID,		P.CobraIVAInteres,		C.TasaFija
					INTO
						Var_FechaMinistrado,	Var_MontoCredito,	Var_CalcInteresID,		Var_CobraIVAInteres,	Var_TasaFija
					FROM CREDITOS C
						INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID = P.ProducCreditoID
						WHERE C.CreditoID = Par_CreditoID;
		        END IF;



				SELECT
					LugarSucursal AS NombreSucMatriz,
					DATE_FORMAT(Var_FechaMinistrado,'%d') AS DiaDesembolso,
					DATE_FORMAT(Var_FechaMinistrado,'%m') AS MesDesembolso,
					DATE_FORMAT(Var_FechaMinistrado,'%Y') AS AnioDesembolso,
					Var_MontoCredito AS MontoCredito,
					CONCAT('****(',FUNCIONNUMLETRAS(Var_MontoCredito),' M.N.)****') AS MontoEnLetras,
					IF(IFNULL(Var_CalcInteresID, Entero_Cero) = 1,'FIJO','VARIABLE') AS TipoInteres,
					Var_TasaFija AS PorcentajeTasa,
					IF(IFNULL(Var_CobraIVAInteres,Cons_NO) = Cons_SI,'MAS IVA','SIN IVA') AS Iva;
			END IF;

			-- SECCION SUSCRIPTORES
			IF(Par_Seccion = Sec_suscrip)THEN
				SELECT
					G.GrupoID,		G.NombreGrupo,		C.CicloGrupo
				INTO
					Var_GrupoID,	Var_NombreGrupo,	Var_CicloGrupo
					FROM CREDITOS C
						INNER JOIN GRUPOSCREDITO G ON(C.GrupoID=G.GrupoID)
					WHERE CreditoID = Par_CreditoID;

				SET Var_GrupoID		:= IFNULL(Var_GrupoID, Entero_Cero);
				SET Var_CicloGrupo	:= IFNULL(Var_CicloGrupo, Entero_Cero);

				DROP TABLE IF  EXISTS TMPACREDSTAFEPAG;
                CREATE TABLE IF NOT EXISTS TMPACREDSTAFEPAG(
					ConsecutivoID		BIGINT(12),
					ClienteID			INT(11),
					SolicitudCreditoID	INT(11),
					NombreCompleto		VARCHAR(500) DEFAULT '',
					Domicilio			VARCHAR(500) DEFAULT '',
					Telefono			VARCHAR(500) DEFAULT '',
					CreditoIDInt		BIGINT(12),
					CreditoID			BIGINT(12),
					INDEX(ConsecutivoID),
					INDEX(ClienteID),
					INDEX(SolicitudCreditoID),
					INDEX(CreditoIDInt),
					INDEX(CreditoID)
				);

				IF(IFNULL(Var_GrupoID, Entero_Cero) = Entero_Cero) THEN
					INSERT INTO TMPACREDSTAFEPAG(
						ConsecutivoID,
						ClienteID,				NombreCompleto,			Telefono,				CreditoID,		CreditoIDInt,
						SolicitudCreditoID,		Domicilio)
					SELECT
						Entero_Cero,
						cl.ClienteID,			cl.NombreCompleto,		cl.TelefonoCelular,		Par_CreditoID,	cr.CreditoID,
						cr.SolicitudCreditoID,	dc.DireccionCompleta
					FROM
						CREDITOS cr
					LEFT OUTER JOIN CLIENTES cl
						ON cr.ClienteID = cl.ClienteID
					LEFT OUTER JOIN DIRECCLIENTE dc
						ON cr.ClienteID = dc.ClienteID AND dc.Oficial = DirOficial_Si
					WHERE cr.CreditoID = Par_CreditoID;
				ELSE
					-- Datos Generales De Los Integrantes Del Grupo
					SET @Var_Consecutivo := Entero_Cero;

					INSERT INTO TMPACREDSTAFEPAG(
						ConsecutivoID,
						ClienteID,				NombreCompleto,			Telefono,		CreditoID,		CreditoIDInt,
						SolicitudCreditoID)
					SELECT
						(@Var_Consecutivo := @Var_Consecutivo +1),
						CTE.ClienteID,			CTE.NombreCompleto,		CTE.Telefono,	Par_CreditoID,	C.CreditoID,
						C.SolicitudCreditoID
					FROM CREDITOS C
						INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
						INNER JOIN INTEGRAGRUPOSCRE G on C.SolicitudCreditoID = G.SolicitudCreditoID
						INNER JOIN CLIENTES CTE ON G.ClienteID = CTE.ClienteID
					WHERE G.GrupoID = Var_GrupoID
							AND G.Estatus = EstatusAut
						ORDER BY G.Cargo;

					-- Actualización del domicilio.
					UPDATE TMPACREDSTAFEPAG T
						LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
					SET T.Domicilio = UPPER(D.DireccionCompleta)
						WHERE T.ClienteID != Entero_Cero
							AND T.CreditoID = Par_CreditoID;
				END IF;

                -- INICIA SECCION DE AVALES Y OBLIGADOS SOLIDARIOS*/
				DROP TABLE IF EXISTS TMPAVALSTAFEPAG;
				CREATE TABLE IF NOT EXISTS TMPAVALSTAFEPAG(
					ConsecutivoID		BIGINT(12),
					ClienteID			INT(11),
					AvalID				INT(11),
					ProspectoID			INT(11),
					SolicitudCreditoID	INT(11),
					NombreCompleto		VARCHAR(500) DEFAULT '',
					Domicilio			VARCHAR(500) DEFAULT '',
					Telefono			VARCHAR(500) DEFAULT '',
					CreditoID			BIGINT(12),
					INDEX(ConsecutivoID),
					INDEX(ClienteID),
					INDEX(AvalID),
					INDEX(ProspectoID),
					INDEX(SolicitudCreditoID),
					INDEX(CreditoID)
				);

				SET @Var_Consecutivo := Entero_Cero;

				-- Datos de los Avales de los Integrantes del Grupo.
				INSERT INTO TMPAVALSTAFEPAG(
					ConsecutivoID,
					ClienteID,			AvalID,				ProspectoID,
					CreditoID)
				SELECT DISTINCT
					Entero_Cero,
					IFNULL(ASOL.ClienteID, Entero_Cero),	IFNULL(ASOL.AvalID, Entero_Cero),	IFNULL(ASOL.ProspectoID, Entero_Cero),
					Par_CreditoID
					FROM TMPACREDSTAFEPAG TMP
						INNER JOIN AVALESPORSOLICI ASOL ON TMP.SolicitudCreditoID=ASOL.SolicitudCreditoID
					WHERE ASOL.Estatus = EstatusAutU
						AND TMP.CreditoID = Par_CreditoID;

				-- Avales que son clientes
				UPDATE TMPAVALSTAFEPAG T
					INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
					LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
				SET T.Domicilio = UPPER(IFNULL(D.DireccionCompleta, Cadena_Vacia)),
					T.NombreCompleto = C.NombreCompleto,
					T.Telefono = C.Telefono
					WHERE T.ClienteID != Entero_Cero
						AND T.CreditoID = Par_CreditoID;

				-- Avales que no son clientes ni prospectos
				UPDATE TMPAVALSTAFEPAG T
					INNER JOIN AVALES A ON (T.AvalID=A.AvalID)
				SET T.Domicilio = UPPER(A.DireccionCompleta),
					T.NombreCompleto = A.NombreCompleto,
					T.Telefono = A.Telefono
					WHERE T.AvalID != Entero_Cero
						AND T.CreditoID = Par_CreditoID
						AND T.ClienteID = Entero_Cero
						AND T.ProspectoID = Entero_Cero;

				-- Avales que son sólo prospectos
				UPDATE TMPAVALSTAFEPAG T
					INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
				SET T.Domicilio = UPPER(FNGENDIRECCION(1, P.EstadoID, P.MunicipioID, P.LocalidadID, P.ColoniaID,
											P.Calle, P.NumExterior, P.NumInterior, Cadena_Vacia, Cadena_Vacia,
											Cadena_Vacia, P.CP, Cadena_Vacia, P.Lote, P.Manzana)),
					T.NombreCompleto = P.NombreCompleto,
					T.Telefono = P.Telefono
					WHERE T.ClienteID = Entero_Cero
						AND T.CreditoID = Par_CreditoID
						AND T.ProspectoID != Entero_Cero
						AND T.AvalID = Entero_Cero;

				-- OBLIGADOS SOLIDARIOS
                DROP TABLE IF EXISTS TMPOBLISTAFEPAG;
				CREATE TABLE IF NOT EXISTS TMPOBLISTAFEPAG(
					ConsecutivoID		BIGINT(12),
					ClienteID			INT(11),
					ObligadoID				INT(11),
					ProspectoID			INT(11),
					SolicitudCreditoID	INT(11),
					NombreCompleto		VARCHAR(500) DEFAULT '',
					Domicilio			VARCHAR(500) DEFAULT '',
					Telefono			VARCHAR(500) DEFAULT '',
					CreditoID			BIGINT(12),
					INDEX(ConsecutivoID),
					INDEX(ClienteID),
					INDEX(ObligadoID),
					INDEX(ProspectoID),
					INDEX(SolicitudCreditoID),
					INDEX(CreditoID)
				);

				SET @Var_Consecutivo := Entero_Cero;

				-- Datos de los Obligados de los Integrantes del Grupo.
				INSERT INTO TMPOBLISTAFEPAG(
					ConsecutivoID,
					ClienteID,			ObligadoID,				ProspectoID,
					CreditoID)
				SELECT DISTINCT
					Entero_Cero,
					IFNULL(OSOL.ClienteID, Entero_Cero),	IFNULL(OSOL.OblSolidID, Entero_Cero),	IFNULL(OSOL.ProspectoID, Entero_Cero),
					Par_CreditoID
					FROM TMPACREDSTAFEPAG TMP
						INNER JOIN OBLSOLIDARIOSPORSOLI OSOL ON TMP.SolicitudCreditoID = 	OSOL.SolicitudCreditoID
					WHERE OSOL.Estatus = EstatusAutU
						AND TMP.CreditoID = Par_CreditoID;

				-- Obligados que son clientes
				UPDATE TMPOBLISTAFEPAG T
					INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
					LEFT OUTER JOIN DIRECCLIENTE D ON (T.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
				SET T.Domicilio = UPPER(IFNULL(D.DireccionCompleta, Cadena_Vacia)),
					T.NombreCompleto = C.NombreCompleto,
					T.Telefono = C.Telefono
					WHERE T.ClienteID != Entero_Cero
						AND T.CreditoID = Par_CreditoID;

				-- Obligados que no son clientes ni prospectos
				UPDATE TMPOBLISTAFEPAG T
					INNER JOIN OBLIGADOSSOLIDARIOS A ON (T.ObligadoID = A.OblSolidID)
				SET T.Domicilio = UPPER(A.DireccionCompleta),
					T.NombreCompleto = A.NombreCompleto,
					T.Telefono = A.Telefono
					WHERE T.ObligadoID != Entero_Cero
						AND T.CreditoID = Par_CreditoID
						AND T.ClienteID = Entero_Cero
						AND T.ProspectoID = Entero_Cero;

				-- Avales que son sólo prospectos
				UPDATE TMPOBLISTAFEPAG T
					INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
				SET T.Domicilio = UPPER(FNGENDIRECCION(1, P.EstadoID, P.MunicipioID, P.LocalidadID, P.ColoniaID,
											P.Calle, P.NumExterior, P.NumInterior, Cadena_Vacia, Cadena_Vacia,
											Cadena_Vacia, P.CP, Cadena_Vacia, P.Lote, P.Manzana)),
					T.NombreCompleto = P.NombreCompleto,
					T.Telefono = P.Telefono
					WHERE T.ClienteID = Entero_Cero
						AND T.CreditoID = Par_CreditoID
						AND T.ProspectoID != Entero_Cero
						AND T.ObligadoID = Entero_Cero;


                -- AVALES Y OBLIGADOS SOLIDARIOS
                DROP TABLE IF EXISTS TMPAVALYOBLI;
                CREATE TABLE IF NOT EXISTS TMPAVALYOBLI(
					SolicitudCreditoID	INT(11),
					NombreCompleto		VARCHAR(500) DEFAULT '',
					Domicilio			VARCHAR(500) DEFAULT '',
					Telefono			VARCHAR(500) DEFAULT '',
					CreditoID			BIGINT(12),
					INDEX(SolicitudCreditoID),
					INDEX(CreditoID)
				);

                INSERT INTO TMPAVALYOBLI
                SELECT SolicitudCreditoID, NombreCompleto, Domicilio, Telefono, CreditoID
                FROM TMPAVALSTAFEPAG
					WHERE ClienteID NOT IN (SELECT ClienteID FROM TMPAVALSTAFEPAG WHERE ClienteID <> Entero_Cero);


                INSERT INTO TMPAVALYOBLI
                SELECT MAX(SolicitudCreditoID), MAX(NombreCompleto),
						MAX(Domicilio), MAX(Telefono), MAX(CreditoID) FROM TMPOBLISTAFEPAG WHERE IFNULL(ObligadoID,Entero_Cero) <> Entero_Cero GROUP BY ObligadoID;

               SET conta := (SELECT COUNT(*) FROM TMPAVALYOBLI);
               SET conta := IFNULL(conta,Entero_Cero);
                -- TERMINA SECCION DE AVALES Y OBLIGADOS

				SELECT
					NombreCompleto AS NombreCliente,	IFNULL(Domicilio, Cadena_Vacia) AS DireccionCte,
					FNMASCARA(Telefono,'(###) ###-####') AS TelefonoCelular, conta
				FROM TMPACREDSTAFEPAG
					WHERE CreditoID = Par_CreditoID
					ORDER BY ConsecutivoID;
			END IF;
			-- FIN SECCION SUCRIPTORES

			-- SECCION AVALES
			IF(Par_Seccion = Sec_avales) THEN

                SELECT
					TMP.NombreCompleto AS aval,		TMP.Domicilio AS direcAval,
					FNMASCARA(TMP.Telefono,'(###) ###-####') AS telefono
				FROM TMPAVALYOBLI TMP
					WHERE CreditoID = Par_CreditoID
					ORDER BY CreditoID;

			END IF;-- FIN SECCION AVALES

			-- SECCION GARANTES
			IF(Par_Seccion = Sec_garnts) THEN

				DROP TABLE IF EXISTS TEMP_GARANTES;
				CREATE TEMPORARY TABLE TEMP_GARANTES(
					Garante  		VARCHAR(300),
					DirecGarante 	VARCHAR(300),
					TipoPersona 	CHAR(1),
					ClienteID		INT(11),
					NombreRepresen  VARCHAR(300),
					KEY(ClienteID)
				);

				-- INSERTA GARANTES QUE SON CLIENTES
				INSERT INTO TEMP_GARANTES(
				SELECT Cli.NombreCompleto,Dir.DireccionCompleta, Cli.TipoPersona, IFNULL(Gar.ClienteID,Entero_Cero),
						Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Gar.ClienteID
				INNER JOIN DIRECCLIENTE Dir ON Cli.ClienteID = Dir.ClienteID
					AND Dir.Oficial = DirOficial_Si
				WHERE Sol.CreditoID = Par_CreditoID);


				-- INSERTA GARANTES QUE SON AVALES
				INSERT INTO TEMP_GARANTES(
				SELECT Ava.NombreCompleto,CONCAT(
											IFNULL(Ava.Calle,''), ' ',
											IFNULL(Ava.NumExterior,''), ', COL. ',
											IFNULL(Ava.Colonia,''), ' CP. ',
											IFNULL(Ava.CP,''),' ,',
											IFNULL(Mun.Nombre,''), ' ,',
											IFNULL(Edo.Nombre,'')),
											Ava.TipoPersona, Entero_Cero,Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				INNER JOIN AVALES Ava ON Ava.AvalID = Gar.AvalID
				INNER JOIN ESTADOSREPUB Edo ON Ava.EstadoID = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Ava.EstadoID = Mun.EstadoID
					AND Ava.MunicipioID = Mun.MunicipioID
				WHERE Sol.CreditoID = Par_CreditoID);


				-- GARANTES QUE SON PROSPECTOS
				INSERT INTO TEMP_GARANTES(
				SELECT Pro.NombreCompleto,CONCAT(
											IFNULL(Pro.Calle,''),', NO. ',
											IFNULL(Pro.NumExterior,''),', INTERIOR ',
											IFNULL(Pro.NumInterior,''),', COL. ',
											IFNULL(Pro.Colonia,''),' C.P. ',
											IFNULL(Pro.CP,''),', ',
											IFNULL(Mun.Nombre,''), ', ',
											IFNULL(Edo.Nombre,'')),
											Pro.TipoPersona,IFNULL(Pro.ClienteID,Entero_Cero),Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				INNER JOIN PROSPECTOS Pro ON Gar.ProspectoID = Pro.ProspectoID AND Gar.ClienteID = Entero_Cero
				INNER JOIN ESTADOSREPUB Edo ON Pro.EstadoID = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Pro.EstadoID = Mun.EstadoID
					AND Pro.MunicipioID = Mun.MunicipioID
				WHERE Sol.CreditoID = Par_CreditoID);

				-- GARANTES QUE NO SON CLIENTE NI PROPSECTOS
				INSERT INTO TEMP_GARANTES(
				SELECT Gar.GaranteNombre,CONCAT(
											IFNULL(Gar.CalleGarante,''),', NO. ',
											IFNULL(Gar.NumExtGarante,''),', INTERIOR ',
											IFNULL(Gar.NumIntGarante,''),', COL. ',
											IFNULL(Gar.ColoniaGarante,''),' C.P. ',
											IFNULL(Gar.CodPostalGarante,''),', ',
											IFNULL(Mun.Nombre,''), ', ',
											IFNULL(Edo.Nombre,'')),
											"F",Entero_Cero,Cadena_Vacia
				FROM ASIGNAGARANTIAS Asi
				INNER JOIN SOLICITUDCREDITO Sol ON Asi.SolicitudCreditoID = Sol.SolicitudCreditoID and Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN GARANTIAS Gar ON Asi.GarantiaID = Gar.GarantiaID
				AND Gar.ClienteID = Entero_Cero AND Gar.AvalID = Entero_Cero
					AND Gar.ProspectoID = Entero_Cero
				INNER JOIN ESTADOSREPUB Edo ON Gar.EstadoIDGarante = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun ON Gar.EstadoIDGarante = Mun.EstadoID
					AND Gar.MunicipioGarante = Mun.MunicipioID
				WHERE Sol.CreditoID = Par_CreditoID);

				-- ACTUALIZA DATOS DEL REPRESENTA LEGAL SI ES PERSONA MORAL
				UPDATE TEMP_GARANTES tmp
					LEFT JOIN CUENTASAHO cta
						ON tmp.ClienteID = cta.ClienteID
							AND cta.EsPrincipal = Cons_SI
					LEFT JOIN CUENTASPERSONA per
						ON cta.CuentaAhoID = per.CuentaAhoID
							AND per.EsApoderado = Cons_SI
				SET tmp.NombreRepresen = per.NombreCompleto
				WHERE  tmp.ClienteID > Entero_Cero
					AND tmp.TipoPersona = 'M';

				SELECT 	Garante AS garante,	DirecGarante AS direcGarante, TipoPersona,	NombreRepresen
				FROM TEMP_GARANTES tmp;

			END IF;-- FIN SECCION GARANTES
    END IF;

END TerminaStore$$