-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGAREAVIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGAREAVIOREP`;DELIMITER $$

CREATE PROCEDURE `PAGAREAVIOREP`(
	Par_CreditoID				BIGINT(12),
	Par_SeccionReporte			INT(11),

	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_TipoTasa		CHAR(1);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_ProductoID		INT(11);
	DECLARE Var_MontoCredito	DECIMAL(14,2);
	DECLARE Var_ImportePagare	DECIMAL(14,2);
	DECLARE Var_FechaVencimien	DATE;
	DECLARE Var_FechaSuscripcion DATE;
	DECLARE Var_TasaFija		DECIMAL(12,4);
    DECLARE Var_FactorMora		DECIMAL(12,4);
    DECLARE Var_AlContratar		DECIMAL(12,2);
    DECLARE Var_NombreComp		VARCHAR(200);
    DECLARE Var_DirCompleto		VARCHAR(200);
    DECLARE Var_SoliCredID		INT(11);
    DECLARE Var_TipoPersona		CHAR(1);
    DECLARE Var_ClasificaID		INT(11);
    DECLARE Var_DestinoCreID	INT(11);
    DECLARE Var_CuentaAhoID		BIGINT(12);
    DECLARE Var_TipoMora   		CHAR(1);
	DECLARE Var_SucursalID		INT(11);
    DECLARE Var_NombreSuc		VARCHAR(50);
    DECLARE Var_DirSucursal		VARCHAR(250);
    DECLARE Var_CiudadEstado	VARCHAR(150);
	DECLARE Var_DiaV			VARCHAR(60);
    DECLARE Var_MesV			VARCHAR(60);
    DECLARE Var_AnioV			VARCHAR(60);
	DECLARE Var_DiaS			VARCHAR(60);
    DECLARE Var_MesS			VARCHAR(60);
    DECLARE Var_AnioS			VARCHAR(60);
    DECLARE Var_MesLetrasV		VARCHAR(60);
    DECLARE Var_MesLetrasS		VARCHAR(60);
    DECLARE Var_Calle			VARCHAR(100);
    DECLARE	Var_Numero			VARCHAR(100);
    DECLARE Var_Colonia			VARCHAR(100);
    DECLARE Var_CP				VARCHAR(100);
    DECLARE Var_Localidad		VARCHAR(100);
    DECLARE Var_Estado			VARCHAR(100);
    -- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Con_PersonaF		CHAR(1);
	DECLARE Con_PersonaM		CHAR(1);
	DECLARE Con_TasaFija		CHAR(1);
	DECLARE Con_TasaVariable	CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Con_DatosBase		INT(11);
	DECLARE Con_Amortizaciones	INT(11);
	DECLARE Con_Ministraciones	INT(11);
	DECLARE Con_Deudores		INT(11);
	DECLARE Con_Avales			INT(11);
	DECLARE Con_Pesos			VARCHAR(10);
	DECLARE Con_MonedaNac		VARCHAR(12);
	DECLARE Con_SimboloMoneda	CHAR(1);
	DECLARE Con_Espacio			CHAR(1);
	DECLARE DirOficial_Si		CHAR(1);
	DECLARE Con_Refacionaria	INT(11);
	DECLARE Con_Si 				CHAR(1);
	DECLARE Entero_Dos			INT(11);


	-- seteo de constantes
	SET Con_TasaFija			:=	1;
	SET Con_PersonaF			:=	'F';
	SET Con_PersonaM			:=	'M';
	SET Con_DatosBase			:=	1;
	SET Con_Ministraciones		:=	2;
    SET Con_Amortizaciones		:= 	3;
    SET Con_Deudores			:=	4;
    SET Con_Avales				:=	5;

	SET Con_MonedaNac			:=' 00/100 M.N.';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Con_SimboloMoneda		:= '$';
    SET Con_Espacio				:= ' ';
    SET DirOficial_Si			:=	'S';
    SET Con_Refacionaria		:= 126;
    SET Con_Si 					:=	'S';
    SET Entero_Dos				:= 2;
    -- Datos del credito.
	SELECT 	ClienteID,		CuentaID,				ProductoCreditoID,	DestinoCreID,		FechaVencimien,
			TasaFija,		FactorMora,				MontoCredito,		SolicitudCreditoID,	TipCobComMorato,
            SucursalID
	INTO	Var_ClienteID,	Var_CuentaAhoID,		Var_ProductoID,		Var_DestinoCreID,	Var_FechaVencimien,
			Var_TasaFija,	Var_FactorMora,			Var_ImportePagare,	Var_SoliCredID,		Var_TipoMora,
            Var_SucursalID
	FROM CREDITOS
	WHERE CreditoID = Par_CreditoID;

    -- Si el tipo de cobro de moratorios es de N veces tasa ordinaria
    IF(Var_TipoMora = 'N')THEN
		SET Var_FactorMora := Var_FactorMora * Var_TasaFija;
    END IF;

    -- Monto al contratar.
    SELECT Capital INTO Var_AlContratar
		FROM MINISTRACREDAGRO
		WHERE CreditoID = Par_CreditoID
			AND Numero = 1;

	-- monto total a pagar
	SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_MontoCredito
      FROM CREDITOS Cre,
         AMORTICREDITO Amo
      WHERE Cre.CreditoID = Par_CreditoID
        AND Amo.CreditoID = Cre.CreditoID;

	-- para saber si es tipo Tasa Fija o Diferente de esta.
	SELECT CalcInteres
	INTO Var_TipoTasa
	FROM PRODUCTOSCREDITO
	WHERE ProducCreditoID= Var_ProductoID;

	-- Fecha de Suscripcion
	SELECT  FechaMinistracion
	INTO 	Var_FechaSuscripcion
	FROM 	MINISTRACREDAGRO
	WHERE  CreditoID=Par_CreditoID AND Numero = Entero_Uno;

	SELECT TipoPersona INTO Var_TipoPersona
	FROM CLIENTES
	WHERE ClienteID= Var_ClienteID;


	SELECT SubClasifID INTO Var_ClasificaID
	FROM DESTINOSCREDITO WHERE DestinoCreID=Var_DestinoCreID;

	SELECT NombreSucurs,
        CONCAT(UPPER(LEFT(LOWER(S.Calle),1)),CONCAT(SUBSTRING(LOWER(S.Calle),2))),
        CONCAT('No.',S.Numero),
        CONCAT('Col. ',CONCAT(UPPER(LEFT(LOWER(S.Colonia),1)),CONCAT(SUBSTRING(LOWER(S.Colonia),2)))),
        CONCAT('C.P. ',S.CP),
        CONCAT(UPPER(LEFT(LOWER(L.NombreLocalidad),1)),CONCAT(SUBSTRING(LOWER(L.NombreLocalidad),2))),
        CONCAT(UPPER(LEFT(LOWER(E.Nombre),1)),CONCAT(SUBSTRING(LOWER(E.Nombre),2))),
        CONCAT(L.NombreLocalidad,', ',E.Nombre)
        INTO Var_NombreSuc,Var_Calle,Var_Numero,Var_Colonia,Var_CP,Var_Localidad,Var_Estado,Var_CiudadEstado
   FROM SUCURSALES S
    INNER JOIN ESTADOSREPUB E ON S.EstadoID = E.EstadoID
    INNER JOIN MUNICIPIOSREPUB M ON S.MunicipioID = M.MunicipioID AND E.EstadoID = M.EstadoID
    INNER JOIN LOCALIDADREPUB L ON  S.LocalidadID= L.LocalidadID
    AND M.MunicipioID = L.MunicipioID
    AND L.EstadoID = E.EstadoID
    WHERE S.SucursalID= Entero_Dos;

		-- Datos Base del reporte
			IF(Par_SeccionReporte = Con_DatosBase)THEN
				-- Si el producto de credito es TasaFija
                SET Var_DiaV  := CONCAT(DAY(Var_FechaVencimien),' (',LOWER(FUNCIONSOLONUMLETRAS(SUBSTRING(Var_FechaVencimien,9,2))),') de ');
                SET Var_MesV  := CASE MONTH(Var_FechaVencimien)
									WHEN 1	THEN 'Enero'
									WHEN 2	THEN 'Febrero'
									WHEN 3	THEN 'Marzo'
									WHEN 4	THEN 'Abril'
									WHEN 5	THEN 'Mayo'
									WHEN 6	THEN 'Junio'
									WHEN 7	THEN 'Julio'
									WHEN 8	THEN 'Agosto'
									WHEN 9	THEN 'Septiembre'
									WHEN 10	THEN 'Octubre'
									WHEN 11	THEN 'Noviembre'
									WHEN 12	THEN 'Diciembre'
								END;

                SET Var_AnioV := CONCAT(' de ',YEAR(Var_FechaVencimien),' (',LOWER(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaVencimien))),')');
                SET Var_MesLetrasV  := CONCAT(Var_DiaV,Var_MesV,Var_AnioV);

                SET Var_DiaS  := CONCAT(DAY(Var_FechaSuscripcion),' (',LOWER(FUNCIONSOLONUMLETRAS(SUBSTRING(Var_FechaSuscripcion,9,2))),') de ');
                SET Var_MesS  := CASE MONTH(Var_FechaSuscripcion)
									WHEN 1	THEN 'Enero'
									WHEN 2	THEN 'Febrero'
									WHEN 3	THEN 'Marzo'
									WHEN 4	THEN 'Abril'
									WHEN 5	THEN 'Mayo'
									WHEN 6	THEN 'Junio'
									WHEN 7	THEN 'Julio'
									WHEN 8	THEN 'Agosto'
									WHEN 9	THEN 'Septiembre'
									WHEN 10	THEN 'Octubre'
									WHEN 11	THEN 'Noviembre'
									WHEN 12	THEN 'Diciembre'
								END;

                SET Var_AnioS := CONCAT(' de ',YEAR(Var_FechaSuscripcion),' (',LOWER(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaSuscripcion))),')');
                SET Var_MesLetrasS  := CONCAT(Var_DiaS,Var_MesS,Var_AnioS);

                IF MOD(Var_AlContratar,1000000) = Entero_Cero THEN
					SET Con_Pesos:=' DE PESOS ';
                ELSE
 					SET Con_Pesos:=' PESOS ';
                END IF;

				IF(Var_TipoTasa = Con_TasaFija) THEN
					SELECT 	Par_CreditoID,FORMAT(Var_AlContratar,2) AS MontoAlContratar,CONCAT(FUNCIONNUMEROSLETRAS(Var_AlContratar),Con_Pesos,Con_MonedaNac) AS MontoAlContratarLetra,Var_FechaVencimien,Var_MesLetrasV AS FechaVencimiento,
							Var_FechaSuscripcion,Var_MesLetrasS AS FechaSuscripcion,Var_TasaFija,
                            CONCAT(SUBSTRING(CONVPORCANT(ROUND(Var_TasaFija,2),'%','2',''), 1, LENGTH(CONVPORCANT(ROUND(Var_TasaFija,2),'%','2',''))-13), ') por ciento') AS TasaFijaAnual,
                            Var_FactorMora, CONCAT(SUBSTRING(CONVPORCANT(ROUND(Var_FactorMora,2),'%','2',''), 1, LENGTH(CONVPORCANT(ROUND(Var_FactorMora,2),'%','2',''))-13), ') por ciento') AS TasaMoratorio,
                            Var_TipoTasa,	FORMAT(Var_ImportePagare,2) AS ImportePagare, CONCAT('(',FUNCIONNUMEROSLETRAS(Var_ImportePagare),Con_Pesos,Con_MonedaNac,')') AS ImportePagareLetra, Var_NombreSuc AS LugarSuscripcion,
                            Var_Calle,Var_Numero,Var_Colonia,Var_CP,Var_Localidad,Var_Estado, Var_CiudadEstado AS CiudadEstado;
				ELSE
				-- Producto de credito Tasa Varible
					SELECT 	Par_CreditoID,Var_AlContratar AS MontoAlContratar,CONCAT(FUNCIONNUMEROSLETRAS(Var_AlContratar),Con_Pesos,Con_MonedaNac) AS MontoAlContratarLetra,Var_FechaVencimien,FUNCIONLETRASFECHA(Var_FechaVencimien) AS FechaVencimiento,
							Var_FechaSuscripcion,FUNCIONLETRASFECHA(Var_FechaSuscripcion) AS FechaSuscripcion,'__.__' AS TasaInterbancaria,Var_AlContratar AS MontoAlContratar,CONCAT(FUNCIONNUMEROSLETRAS(Var_AlContratar),Con_Pesos,Con_MonedaNac) AS MontoAlContratarLetra, Var_TipoTasa,
                            Var_NombreSuc AS LugarSuscripcion,LOWER(Var_DirSucursal) AS DireccionSucursal, Var_CiudadEstado AS Var_CiudadEstado;
				END IF;

			END IF;

			-- Tabla de Ministraciones
			IF(Par_SeccionReporte = Con_Ministraciones)THEN
				SELECT Numero,Capital,CONCAT('(',FUNCIONNUMEROSLETRAS(Capital),CASE WHEN MOD(Capital,1000000)=Entero_Cero THEN 'DE PESOS 'ELSE 'PESOS' END,' 00/100 M.N.',')') AS CapitalLetra, Estatus,
					CASE
						WHEN Numero = 1 THEN "Al Contratar"
						ELSE FUNCIONLETRASFECHA(FechaPagoMinis)
					END AS FechaMinistracion
				FROM MINISTRACREDAGRO
				WHERE CreditoID=Par_CreditoID;
			END IF;
			-- Tabla de Amortizaciones(Vencimientos)
			IF(Par_SeccionReporte = Con_Amortizaciones)THEN
				SELECT AmortizacionID AS Num,FUNCIONLETRASFECHA(FechaVencim) AS FechaVencimientos ,Capital AS MontoCapital,CONCAT('(',FUNCIONNUMEROSLETRAS(Capital),CASE WHEN Capital>=1000000 THEN 'DE PESOS 'ELSE 'PESOS' END,' 00/100 M.N.',')') AS MontoCapitalLetras
				FROM AMORTICREDITOAGRO
				WHERE CreditoID=Par_CreditoID;

			END IF;

			IF(Par_SeccionReporte = Con_Deudores)THEN

				IF(Var_TipoPersona = Con_PersonaM)THEN

					SELECT CP.NombreCompleto,CP.Domicilio,C.RazonSocial,Var_TipoPersona,CONCAT(Var_TipoPersona,Var_ClasificaID) AS MoralAbio
					FROM CUENTASPERSONA CP,CLIENTES C
					WHERE EsApoderado=Con_Si AND
					CuentaAhoID=Var_CuentaAhoID
                    AND C.ClienteID=Var_ClienteID;

				ELSE

					SELECT NombreCompleto, DireccionCompleta,RazonSocial,Var_TipoPersona,CONCAT(Var_TipoPersona,Var_ClasificaID) AS MoralAbio
					FROM CLIENTES C,DIRECCLIENTE  DC
					WHERE C.ClienteID=DC.ClienteID AND C.ClienteID=Var_ClienteID;
				END IF;

			END IF;

			IF(Par_SeccionReporte = Con_Avales)THEN

				DROP TABLE IF EXISTS TEMP_AVALES;
				CREATE TEMPORARY TABLE TEMP_AVALES(
					NombreAval	  		VARCHAR(300),
					DireccionAval	 	VARCHAR(500)
				);



				INSERT INTO TEMP_AVALES(
				SELECT Cli.NombreCompleto,Dir.DireccionCompleta
				FROM AVALESPORSOLICI Avs
				INNER JOIN SOLICITUDCREDITO Sol
					ON Avs.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN CLIENTES Cli
					ON Cli.ClienteID = Avs.ClienteID
				INNER JOIN DIRECCLIENTE Dir
					ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial = DirOficial_Si
				WHERE  Sol.CreditoID = Par_CreditoID
					AND Avs.SolicitudCreditoID = Var_SoliCredID);


				INSERT INTO TEMP_AVALES(
				SELECT Pro.NombreCompleto,CONCAT(
											IFNULL(Pro.Calle,''),', NO. ',
											IFNULL(Pro.NumExterior,''),', INTERIOR ',
											IFNULL(Pro.NumInterior,''),', COL. ',
											IFNULL(Pro.Colonia,''),' C.P. ',
											IFNULL(Pro.CP,''),', ',
											IFNULL(Mun.Nombre,''), ', ',
											IFNULL(Edo.Nombre,''))
				FROM AVALESPORSOLICI Avs
				INNER JOIN SOLICITUDCREDITO Sol
					ON Avs.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN PROSPECTOS Pro
					ON Avs.ProspectoID = Pro.ProspectoID
				INNER JOIN ESTADOSREPUB Edo
					ON Pro.EstadoID = Edo.EstadoID
				INNER JOIN MUNICIPIOSREPUB Mun
					ON Pro.EstadoID = Mun.EstadoID AND Pro.MunicipioID = Mun.MunicipioID
				WHERE  Sol.CreditoID = Par_CreditoID
					AND Avs.SolicitudCreditoID = Var_SoliCredID
                    AND Avs.ClienteID = Entero_Cero);


				INSERT INTO TEMP_AVALES(
				SELECT Ava.NombreCompleto,Ava.DireccionCompleta
				FROM AVALESPORSOLICI Avs
				INNER JOIN SOLICITUDCREDITO Sol
					ON Avs.SolicitudCreditoID = Sol.SolicitudCreditoID AND Sol.SolicitudCreditoID = Var_SoliCredID
				INNER JOIN AVALES Ava
					ON Ava.AvalID = Avs.AvalID
				WHERE  Sol.CreditoID = Par_CreditoID
					AND Avs.SolicitudCreditoID = Var_SoliCredID);


				SELECT * FROM TEMP_AVALES;

			END IF;

END TerminaStore$$