-- EDOCTAV2TIMBRADOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2TIMBRADOPRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAV2TIMBRADOPRO`(
	-- SP creado para el timbrado del Estado de Cuenta
	-- Parametros de Auditoria
	Aud_EmpresaID		INT,                -- Parametro de auditoria
	Aud_Usuario			INT,                -- Parametro de auditoria
	Aud_FechaActual		DATETIME,           -- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),        -- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),        -- Parametro de auditoria
	Aud_Sucursal		INT,                -- Parametro de auditoria
	Aud_NumTransaccion	BIGINT              -- Parametro de auditoria

)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Tasa            DECIMAL(12,2);			-- Valor de la tasa
    DECLARE Var_NumReg          INT(11);				-- Numero de Registros a procesar
    DECLARE Var_AnioMes         CHAR(10);				-- Anio y mes del proceso
    DECLARE Var_SucursalID      INT(11);				-- Numero de Sucursal del Cliente
    DECLARE Var_NombreSucursalCte  VARCHAR(150);		-- Nombre de la Sucursal del Cliente

    DECLARE Var_ClienteID       INT(11);				-- Numero de Cliente
    DECLARE Var_NombreComple    VARCHAR(250);			-- Nombre Completo del Cliente
    DECLARE Var_TipPer          CHAR(2);				-- Tipo de Persona: FISICA (F), MORAL(M), FISICA CON ACTIVIDAD EMPRESARIAL (A)
    DECLARE Var_TipoPersona     VARCHAR(50);			-- Descripcion de Tipo de Persona: FISICA, MORAL, FISICA CON ACTIVIDAD EMPRESARIAL
    DECLARE Var_Calle           VARCHAR(250);			-- Nombre de la calle

    DECLARE Var_NumInt          VARCHAR(10);    		-- Numero Interior del domicilio
    DECLARE Var_NumExt          VARCHAR(10);			-- Numero exterior del domicilio
    DECLARE Var_Colonia         VARCHAR(200);			-- Nombre de la Colinia del cliente
    DECLARE Var_Estado          VARCHAR(50);			-- Nombre del Estado del cliente
    DECLARE Var_CodigoPostal    VARCHAR(10);			-- Codigo Postal del Cliente


    DECLARE Var_RFC             VARCHAR(20);			-- RFC del cliente
    DECLARE Var_ISR   			DECIMAL(12,2);			-- Monto ISR
    DECLARE Var_FechaGeneracion VARCHAR(15);			-- Fecha que se genera el Estado de Cuenta
    DECLARE Var_ComisionAhorro  	DECIMAL(12,2);		-- Monto de la Comision por Ahorro
    DECLARE Var_ComisionCredito 	DECIMAL(12,2);		-- Monto de la Comision por Credito

    DECLARE Var_NombreInstitucion 	VARCHAR(100);		-- Nombre de la Institucion
    DECLARE Var_DireccionInstitucion VARCHAR(150);		-- Direccion de la Institucion
    DECLARE Var_MunicipioDelegacion VARCHAR(50);		-- Municipio de la Institucion
    DECLARE Var_Contador        INT(11);				-- Valor del contador
    DECLARE Var_IntCredito      DECIMAL(12,2);			-- Monto del Interes de Credito

    DECLARE Var_ComMoratorio    DECIMAL(12,2);			-- Monto de la Comision Moratorio
    DECLARE Var_ComFaltaPago    DECIMAL(12,2);			-- Monto de la Comision por Falta de Pago
    DECLARE Var_OtrasCom        DECIMAL(12,2);			-- Monto Otras Comisiones
    DECLARE Var_RazonSocial     VARCHAR(100);			-- Razon Social de la empresa
    DECLARE Var_DirFiscal       VARCHAR(250);			-- Direccion Fiscal de la empresa

    DECLARE Var_RFCEmisor       VARCHAR(25);			-- RFC del emisor
    DECLARE Var_ExpCalle        VARCHAR(50);			-- Nombre de la calle de la sucursal
    DECLARE Var_ExpNumero       VARCHAR(10);			-- Numero de la sucursal
    DECLARE Var_ExpColonia      VARCHAR(50);			-- Colonia de la sucursal
    DECLARE Var_ExpEstado       VARCHAR(50);			-- Estado de la sucursal

    DECLARE Var_ExpMunicipio    VARCHAR(50);			-- Municipio de la sucursal
    DECLARE Var_ExpCP           VARCHAR(10);			-- Codigo postal de la sucursal
    DECLARE Var_GeneraCFDI      CHAR(1);				-- Valor si genera CFDI
    DECLARE Var_RegHacienda     CHAR(1);				-- Valor del Registro en Hacienda
	DECLARE Var_TimbraEdoCta 	CHAR(1);				-- Valor del Timbrado de Estado de Cuenta

    DECLARE Var_EstadoEmisor	VARCHAR(50);			-- Nombre del Estado del emisor
    DECLARE	Var_MuniEmisor		VARCHAR(50);			-- Municipio del emisor
	DECLARE Var_LocalEmisor		VARCHAR(100);			-- Localidad del Emisor
    DECLARE Var_ColEmisor		VARCHAR(100);			-- Colonia del emisor
	DECLARE Var_CalleEmisor		VARCHAR(100);			-- Calle del emisor

    DECLARE Var_NumIntEmisor	VARCHAR(50);			-- Numero interior del domicilio del emisor
    DECLARE Var_NumExtEmisor	VARCHAR(50);			-- Numero exterior del somicilio del emisor
	DECLARE Var_CPEmisor		VARCHAR(50);			-- Codigo postal del emisor

    DECLARE Var_EstatusCade		CHAR(1);				-- ESTATUS DE GENERACION DE CADENA
    DECLARE Var_TotalProd		INT(11);				-- NUMERO DE CLIENTES A PROCESAR CON EL CPRODUCTO
    DECLARE Var_TotalGenCadena	INT(11);				-- TOTAL DE PRODUCTOS A PROCESAR LA CADENA
    DECLARE Var_ProductoID		INT(4);					-- PRODUCTO DE CREDITO
    DECLARE Var_CreditoID		BIGINT(12);				-- CREDITO
    DECLARE Aux_i				INT(11);				-- AUXILIAR I
    DECLARE Aux_z				INT(11);				-- AUXILIAR Z
    DECLARE Var_TotalCli		INT(11);				-- TOTAL DE PRODUCTOS A PROCESAR LA CADENA


	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);					-- Entero Cero
    DECLARE Decimal_Cero        DECIMAL(12,2);				-- Decimal Cero
    DECLARE Cadena_Vacia        CHAR(1);					-- Cadena Vacia
    DECLARE TasaDefault         DECIMAL(12,2);      		-- Valor de la Tasa
	DECLARE TimbraEdoCtaSI		CHAR(1);					-- Timbrado Estado Cuenta: SI
	DECLARE NumSucCorporativo	INT(11);					-- ID del sucursal corporativo
	DECLARE SucTipoCorp			CHAR(1);					-- letra que define a la sucursal tipo corporativo


    -- Asignacion de Constantes
	SET Entero_Cero     	:= 0;					-- Entero Cero
    SET Decimal_Cero    	:= 0.0;					-- Decimal Cero
    SET Cadena_Vacia    	:= '';					-- Cadena Vacia
    SET TasaDefault     	:= 16.00;				-- Valor de la Tasa
    SET	TimbraEdoCtaSI		:= 'S';
    SET SucTipoCorp			:= 'C';


    SELECT SucursalID INTO NumSucCorporativo FROM SUCURSALES WHERE TipoSucursal = SucTipoCorp LIMIT 1;
    SELECT
			MesProceso
		INTO
			Var_AnioMes
		FROM EDOCTAV2PARAMS limit 1; -- MIKE

	-- Se obtiene los datos de la Sucursal
	SELECT Suc.Calle, 		Suc.Numero, 	Suc.Colonia, 		Edo.Nombre, 	Mun.Nombre,
			Suc.CP, 		(Suc.IVA *100) AS IVA
        INTO Var_ExpCalle, 	Var_ExpNumero, 	Var_ExpColonia, 	Var_ExpEstado, 	Var_ExpMunicipio,
			 Var_ExpCP, 	Var_Tasa
        FROM SUCURSALES Suc
        INNER JOIN ESTADOSREPUB Edo ON Suc.EstadoID = Edo.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID AND Suc.MunicipioID = Mun.MunicipioID
        WHERE Suc.SucursalID = NumSucCorporativo;

    -- Se obtiene los datos de la institucion
	SELECT
		Par.TimbraEdoCta,		Ins.Nombre,			Est.Nombre AS Estado,	Mun.Nombre AS Municipio,
		Loc.NombreLocalidad,	Col.Asentamiento,	Ins.CalleEmpresa,		Ins.NumIntEmpresa,
		Ins.NumExtEmpresa, 		Ins.CPEmpresa, 		Ins.RFC, 				Par.GeneraCFDINoReg

		INTO Var_TimbraEdoCta,	Var_RazonSocial,	Var_EstadoEmisor,		Var_MuniEmisor,
			Var_LocalEmisor,	Var_ColEmisor, 		Var_CalleEmisor,		Var_NumIntEmisor,
			Var_NumExtEmisor, 	Var_CPEmisor, 		Var_RFCEmisor, 			Var_GeneraCFDI
		FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
			INNER JOIN ESTADOSREPUB Est ON Ins.EstadoEmpresa = Est.EstadoID
			INNER JOIN MUNICIPIOSREPUB Mun ON Ins.EstadoEmpresa = Mun.EstadoID AND Ins.MunicipioEmpresa = Mun.MunicipioID
			INNER JOIN LOCALIDADREPUB Loc ON Ins.EstadoEmpresa = Loc.EstadoID AND Ins.MunicipioEmpresa = Loc.MunicipioID
								AND Ins.LocalidadEmpresa = Loc.LocalidadID
			INNER JOIN COLONIASREPUB Col ON Ins.EstadoEmpresa = Col.EstadoID AND Ins.MunicipioEmpresa = Col.MunicipioID
								AND Ins.ColoniaEmpresa = Col.ColoniaID;


	SET Var_RFCEmisor		:= IFNULL(Var_RFCEmisor, Cadena_Vacia);
	SET Var_RazonSocial		:= IFNULL(Var_RazonSocial, Cadena_Vacia);
	SET Var_ExpCalle		:= IFNULL(Var_ExpCalle, Cadena_Vacia);
	SET Var_ExpNumero		:= IFNULL(Var_ExpNumero, Cadena_Vacia);
	SET Var_ExpColonia		:= IFNULL(Var_ExpColonia, Cadena_Vacia);
	SET	Var_ExpMunicipio	:= IFNULL(Var_ExpMunicipio, Cadena_Vacia);
	SET Var_ExpEstado		:= IFNULL(Var_ExpEstado, Cadena_Vacia);
	SET Var_ExpCP			:= IFNULL(Var_ExpCP, Cadena_Vacia);
	SET Var_RFC				:= IFNULL(Var_RFC, Cadena_Vacia);
	SET Var_Tasa 			:= IFNULL(Var_Tasa, TasaDefault);
	SET Var_NumIntEmisor 	:= IFNULL(Var_NumIntEmisor, Cadena_Vacia);
	SET Var_NumExtEmisor 	:= IFNULL(Var_NumExtEmisor, Cadena_Vacia);
	SET Var_NumExt 			:= IFNULL(Var_NumExt, Cadena_Vacia);
	SET Var_NumReg 			:= Entero_Cero;
    SET Var_NumReg 			:= (SELECT COUNT(ClienteID) FROM EDOCTAV2DATOSCTE WHERE AnioMes = Var_AnioMes);
	SET Var_CPEmisor		:= IFNULL(Var_CPEmisor, Cadena_Vacia);
    SET Var_NombreInstitucion 		:= IFNULL(Var_NombreInstitucion, Cadena_Vacia);
    SET Var_DireccionInstitucion 	:= IFNULL(Var_DireccionInstitucion, Cadena_Vacia);
    SET Var_MunicipioDelegacion 	:= IFNULL(Var_MunicipioDelegacion, Cadena_Vacia);




    -- Se realiza el timbrado masivo de los estados de cuentas de los clientes
    IF(Var_TimbraEdoCta = TimbraEdoCtaSI )THEN

		TRUNCATE TABLE EDOCTAV2TMP_DATOSCTE;

		INSERT INTO EDOCTAV2TMP_DATOSCTE(ClienteID)
		SELECT Cte.ClienteID
		FROM EDOCTAV2DATOSCTE Cte
		INNER JOIN EDOCTAV2TIMBRADOINGRE TimIng ON Cte.ClienteID = TimIng.ClienteID AND Cte.AnioMes = TimIng.AnioMes
        INNER JOIN EDOCTAV2PARAMSEJECUCION Ejec
        WHERE EstatusTimbrado	= 1
		AND TRIM(CadenaCFDI) = ''
		AND find_in_set(IF( Ejec.TipoEjecucion = 'S', Cte.SucursalID, Cte.ClienteID), Ejec.Instrumentos)
		ORDER BY  IF( Ejec.TipoEjecucion = 'S', Cte.SucursalID,Cte.ClienteID) ;

         SELECT	COUNT(1) INTO Var_TotalCli
				FROM EDOCTAV2TMP_DATOSCTE;


        SET Aux_i := 1;
		WHILE Aux_i <= Var_TotalCli DO

			SET Var_ClienteID =0;

			SET Var_ClienteID = (SELECT ClienteID FROM EDOCTAV2TMP_DATOSCTE WHERE RegistroID =  Aux_i);


			 SELECT	AnioMes,            							SucursalID,     							NombreSucursalCte,  						ClienteID,          							NombreCompleto,
					TipoPer,             							TipoPersona,    							Calle,              						NumInt,            								 NumExt,
					Colonia,            							Estado,         							CodigoPostal,       						RFC,											FechaGeneracion,
					RegHacienda

            INTO	Var_AnioMes,	        						Var_SucursalID,     						Var_NombreSucursalCte, 						Var_ClienteID,      							Var_NombreComple,
                    Var_TipPer,         							Var_TipoPersona,    						Var_Calle,          						Var_NumInt,             						Var_NumExt,
                    Var_Colonia,        							Var_Estado,         						Var_CodigoPostal,   						Var_RFC,						                Var_FechaGeneracion,
                    Var_RegHacienda
			FROM EDOCTAV2DATOSCTE
			WHERE ClienteID = Var_ClienteID;


			CALL EDOCTAV2TIMBRADOCFDISW
									(Var_RFCEmisor,				Var_RazonSocial,			Var_ExpCalle,				Var_ExpNumero,			Var_ExpColonia,
									Var_ExpMunicipio,			Var_ExpEstado,				Var_ExpCP,					Var_Tasa,				Var_NumIntEmisor,
									Var_NumExtEmisor,			Var_NumReg,					Var_CPEmisor,				Var_TimbraEdoCta,		Var_EstadoEmisor,
									Var_MuniEmisor,				Var_LocalEmisor,			Var_ColEmisor,				Var_CalleEmisor,		Var_GeneraCFDI,
									Var_AnioMes,				Var_SucursalID,				Var_NombreSucursalCte,		Var_ClienteID,			Var_NombreComple,
									Var_TipPer,					Var_TipoPersona,			Var_Calle,					Var_NumInt,				Var_NumExt,
									Var_Colonia,				Var_Estado,					Var_CodigoPostal,			Var_RFC,
									Var_FechaGeneracion,		Var_RegHacienda);
			SET Aux_i := Aux_i +1;

		END WHILE;

		SELECT '000' AS NumErr,
			'Proceso Finalizado Correctamente' AS ErrMen,
			Cadena_Vacia AS control,
			Entero_Cero AS consecutivo;
	ELSE
		SELECT '000' AS NumErr,
		'No se realiza el Timbrado[TimbraEdoCta=N] EN PARAMETROSSIS.' AS ErrMen,
		Cadena_Vacia AS control,
		Entero_Cero AS consecutivo;

    END IF;



END TerminaStore$$
