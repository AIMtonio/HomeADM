-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATIMBRADOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATIMBRADOPRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTATIMBRADOPRO`(
	-- SP creado para el timbrado del Estado de Cuenta
    Par_FechaProceso    CHAR(10), 			-- Fecha de Proceso del Estado de Cuenta
    Par_SucursalInicio	INT(11),			-- Sucursal de Inicio
	Par_SucursalFin		INT(11),			-- Sucursal Fin
	Par_ClienteID		INT(11),			-- Numero de Cliente
	Par_Productos		VARCHAR(100),		-- Productos a timbrar
	-- Parametros de Auditoria
	Aud_EmpresaID		INT,                -- Parametro de auditoria
	Aud_Usuario			INT,                -- Parametro de auditoria
	Aud_FechaActual		DATETIME,           -- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),        -- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),        -- Parametro de auditoria
	Aud_Sucursal		INT,                -- Parametro de auditoria
	Aud_NumTransaccion	BIGINT              -- Parametro de auditoria

)
BEGIN

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
    DECLARE Var_ExpCalle        VARCHAR(100);			-- Nombre de la calle de la sucursal
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

    -- Asignacion de Constantes
	SET Entero_Cero     	:= 0;					-- Entero Cero
    SET Decimal_Cero    	:= 0.0;					-- Decimal Cero
    SET Cadena_Vacia    	:= '';					-- Cadena Vacia
    SET TasaDefault     	:= 16.00;				-- Valor de la Tasa
    SET	TimbraEdoCtaSI		:= 'S';


	-- Se obtiene los datos de la Sucursal
	SELECT Suc.Calle, 		Suc.Numero, 	Suc.Colonia, 		Edo.Nombre, 	Mun.Nombre,
			Suc.CP, 		(Suc.IVA *100) AS IVA
        INTO Var_ExpCalle, 	Var_ExpNumero, 	Var_ExpColonia, 	Var_ExpEstado, 	Var_ExpMunicipio,
			 Var_ExpCP, 	Var_Tasa
        FROM SUCURSALES Suc
        INNER JOIN ESTADOSREPUB Edo ON Suc.EstadoID = Edo.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID AND Suc.MunicipioID = Mun.MunicipioID
        WHERE Suc.SucursalID = Aud_Sucursal;

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
    SET Var_NumReg 			:= (SELECT COUNT(ClienteID) FROM EDOCTADATOSCTE WHERE AnioMes = Par_FechaProceso);
	SET Var_CPEmisor		:= IFNULL(Var_CPEmisor, Cadena_Vacia);
	SET Par_ClienteID		:= IFNULL(Par_ClienteID,Entero_Cero);
    SET Var_NombreInstitucion 		:= IFNULL(Var_NombreInstitucion, Cadena_Vacia);
    SET Var_DireccionInstitucion 	:= IFNULL(Var_DireccionInstitucion, Cadena_Vacia);
    SET Var_MunicipioDelegacion 	:= IFNULL(Var_MunicipioDelegacion, Cadena_Vacia);

	-- Se realiza el timbrado del estado de cuenta para un cliente en especifico
	IF (Var_TimbraEdoCta = TimbraEdoCtaSI AND Par_ClienteID != Entero_Cero)THEN

		SELECT
				AnioMes,            		SucursalID,     		NombreSucursalCte,  	ClienteID,          NombreComple,
				TipPer,             		TipoPersona,    		Calle,              	NumInt,             NumExt,
				Colonia,            		Estado,         		CodigoPostal,       	RFC,                ISR,
				FechaGeneracion,    		RegHacienda,    		ComisionAhorro,     	ComisionCredito,    NombreInstitucion,
				DireccionInstitucion, 		MunicipioDelegacion
			INTO
				Var_AnioMes,	        	Var_SucursalID,     	Var_NombreSucursalCte, 	Var_ClienteID,      	Var_NombreComple,
				Var_TipPer,         		Var_TipoPersona,    	Var_Calle,          	Var_NumInt,             Var_NumExt,
				Var_Colonia,        		Var_Estado,         	Var_CodigoPostal,   	Var_RFC,                Var_ISR,
				Var_FechaGeneracion,		Var_RegHacienda,    	Var_ComisionAhorro, 	Var_ComisionCredito,    Var_NombreInstitucion,
				Var_DireccionInstitucion, 	Var_MunicipioDelegacion
			FROM EDOCTADATOSCTE
			WHERE AnioMes = Par_FechaProceso AND ClienteID=Par_ClienteID;

			SET Var_ComisionAhorro 			:= IFNULL(Var_ComisionAhorro, Entero_Cero);
			SET Var_ComisionCredito 		:= IFNULL(Var_ComisionCredito, Entero_Cero);
			SET Var_NombreInstitucion 		:= IFNULL(Var_NombreInstitucion, Cadena_Vacia);
			SET Var_DireccionInstitucion	:= IFNULL(Var_DireccionInstitucion, Cadena_Vacia);
			SET Var_MunicipioDelegacion 	:= IFNULL(Var_MunicipioDelegacion, Cadena_Vacia);

		CALL EDOCTATIMBRADOCFDI(
				Var_RFCEmisor,				Var_RazonSocial	,		Var_ExpCalle,			Var_ExpNumero,			Var_ExpColonia,
				Var_ExpMunicipio,			Var_ExpEstado,			Var_ExpCP,				Var_Tasa,				Var_NumIntEmisor,
				Var_NumExtEmisor,			Var_NumReg,				Var_CPEmisor,			Var_TimbraEdoCta,		Var_EstadoEmisor,
				Var_MuniEmisor,				Var_LocalEmisor,		Var_ColEmisor,			Var_CalleEmisor,		Var_GeneraCFDI,
				Var_AnioMes,				Var_SucursalID,			Var_NombreSucursalCte,	Var_ClienteID,			Var_NombreComple,
				Var_TipPer,					Var_TipoPersona,		Var_Calle,				Var_NumInt,				Var_NumExt,
				Var_Colonia,				Var_Estado,				Var_CodigoPostal,		Var_RFC,				Var_ISR,
				Var_FechaGeneracion,		Var_RegHacienda,		Var_ComisionAhorro,		Var_ComisionCredito,	Var_NombreInstitucion,
				Var_DireccionInstitucion,	Var_MunicipioDelegacion);
	SELECT '000' AS NumErr,
		'Proceso Finalizado Correctamente' AS ErrMen,
		Cadena_Vacia AS control,
		Entero_Cero AS consecutivo;
	ELSE
		SELECT '000' AS NumErr,
		'No se realiza el Timbrado por campo Timbrado Edo Cta.' AS ErrMen,
		Cadena_Vacia AS control,
		Entero_Cero AS consecutivo;
	END IF;
	SET Par_Productos := IFNULL(Par_Productos, Cadena_Vacia);

    -- Se realiza el timbrado masivo de los estados de cuentas de los clientes
    IF(Var_TimbraEdoCta = TimbraEdoCtaSI AND Par_ClienteID = Entero_Cero AND Par_Productos=Cadena_Vacia)THEN

         SELECT	COUNT(AnioMes) INTO Var_TotalCli
				FROM EDOCTADATOSCTE
				WHERE AnioMes = Par_FechaProceso
                AND SucursalID
                BETWEEN Par_SucursalInicio AND Par_SucursalFin;

        SET Aux_i := 0;
		WHILE Aux_i < Var_TotalCli DO

			 SELECT	AnioMes,            		SucursalID,     			NombreSucursalCte,  		ClienteID,          NombreComple,
					TipPer,             		TipoPersona,    			Calle,              		NumInt,             NumExt,
					Colonia,            		Estado,         			CodigoPostal,       		RFC,                ISR,
					FechaGeneracion,    		RegHacienda,    			IFNULL(ComisionAhorro,Entero_Cero),     	IFNULL(ComisionCredito,Entero_Cero),
					IFNULL(NombreInstitucion,Cadena_Vacia),	IFNULL(DireccionInstitucion,Cadena_Vacia), 	IFNULL(MunicipioDelegacion,Cadena_Vacia)
            INTO	Var_AnioMes,	        	Var_SucursalID,     		Var_NombreSucursalCte, 		Var_ClienteID,      	Var_NombreComple,
                    Var_TipPer,         		Var_TipoPersona,    		Var_Calle,          		Var_NumInt,             Var_NumExt,
                    Var_Colonia,        		Var_Estado,         		Var_CodigoPostal,   		Var_RFC,                Var_ISR,
                    Var_FechaGeneracion,		Var_RegHacienda,    		Var_ComisionAhorro, 		Var_ComisionCredito,    Var_NombreInstitucion,
                    Var_DireccionInstitucion, 	Var_MunicipioDelegacion
			FROM EDOCTADATOSCTE
			WHERE AnioMes = Par_FechaProceso
            AND SucursalID
            BETWEEN Par_SucursalInicio AND Par_SucursalFin
            ORDER BY ClienteID LIMIT Aux_i, 1;


			CALL EDOCTATIMBRADOCFDI(Var_RFCEmisor,				Var_RazonSocial,			Var_ExpCalle,				Var_ExpNumero,			Var_ExpColonia,
									Var_ExpMunicipio,			Var_ExpEstado,				Var_ExpCP,					Var_Tasa,				Var_NumIntEmisor,
									Var_NumExtEmisor,			Var_NumReg,					Var_CPEmisor,				Var_TimbraEdoCta,		Var_EstadoEmisor,
									Var_MuniEmisor,				Var_LocalEmisor,			Var_ColEmisor,				Var_CalleEmisor,		Var_GeneraCFDI,
									Var_AnioMes,				Var_SucursalID,				Var_NombreSucursalCte,		Var_ClienteID,			Var_NombreComple,
									Var_TipPer,					Var_TipoPersona,			Var_Calle,					Var_NumInt,				Var_NumExt,
									Var_Colonia,				Var_Estado,					Var_CodigoPostal,			Var_RFC,				Var_ISR,
									Var_FechaGeneracion,		Var_RegHacienda,			Var_ComisionAhorro,			Var_ComisionCredito,	Var_NombreInstitucion,
									Var_DireccionInstitucion,	Var_MunicipioDelegacion);
			SET Aux_i := Aux_i +1;

		END WHILE;

		SELECT '000' AS NumErr,
			'Proceso Finalizado Correctamente' AS ErrMen,
			Cadena_Vacia AS control,
			Entero_Cero AS consecutivo;
	ELSE
		SELECT '000' AS NumErr,
		'No se realiza el Timbrado por campo Timbrado Edo Cta.' AS ErrMen,
		Cadena_Vacia AS control,
		Entero_Cero AS consecutivo;

    END IF;


	-- Se realiza el timbrado masivo de los estados de cuentas deL cliente CREDICLUB
	IF (Var_TimbraEdoCta = TimbraEdoCtaSI AND Par_ClienteID = Entero_Cero AND Par_Productos !="")THEN

        SET Var_TotalGenCadena :=LENGTH(Par_Productos) - LENGTH(REPLACE(Par_Productos, ",", ''))+1;
		SET Aux_i := 0;
		WHILE Aux_i < Var_TotalGenCadena DO
			SET Aux_i := Aux_i +1;
            SET Var_ProductoID := 0;
            SET Var_ProductoID := TRIM(FNSPLIT_STRING(Par_Productos,',',Aux_i));
            SET Var_TotalProd := 0;
            SET Var_TotalProd := (SELECT COUNT(AnioMes)
									FROM EDOCTADATOSCTE
                                    WHERE AnioMes = Par_FechaProceso
									AND ProductoCredID = Var_ProductoID);

            SET Var_EstatusCade :=(SELECT EstatusCadenaProd
									FROM EDOCTADATOSCTE
                                    WHERE AnioMes = Par_FechaProceso
									AND ProductoCredID = Var_ProductoID
                                    AND EstatusCadenaProd ="S"
									LIMIT 1);

            SET Var_TotalProd := IFNULL(Var_TotalProd, 0);
			SET Var_EstatusCade :=IFNULL(Var_EstatusCade,'N');

            IF(Var_TotalProd > 0 AND Var_EstatusCade = "N")THEN
				SET Aux_z := 0;
				WHILE Aux_z < Var_TotalProd DO

					 SELECT		AnioMes,            			SucursalID,     	NombreSucursalCte,  		ClienteID,          	NombreComple,
								TipPer,          				TipoPersona,    	Calle,             		 	NumInt,             	NumExt,
                                Colonia, 	          		 	Estado,            	CodigoPostal,      			RFC,                	ISR,
                                FechaGeneracion,    			RegHacienda,
                                CreditoID,
                                IFNULL(DireccionInstitucion,Cadena_Vacia),
                                IFNULL(ComisionAhorro,Entero_Cero),
                                IFNULL(ComisionCredito,Entero_Cero),
								IFNULL(NombreInstitucion,Cadena_Vacia),
                                IFNULL(MunicipioDelegacion,Cadena_Vacia)
						INTO 	Var_AnioMes,	        		Var_SucursalID,     Var_NombreSucursalCte, 		Var_ClienteID,      	Var_NombreComple,
								Var_TipPer,         			Var_TipoPersona,    Var_Calle,          		Var_NumInt,             Var_NumExt,
								Var_Colonia,        			Var_Estado,         Var_CodigoPostal,   		Var_RFC,                Var_ISR,
								Var_FechaGeneracion,			Var_RegHacienda,
								Var_CreditoID,
                                Var_DireccionInstitucion,
                                Var_ComisionAhorro,
                                Var_ComisionCredito,
                                Var_NombreInstitucion,
                                Var_MunicipioDelegacion
						FROM EDOCTADATOSCTE
						WHERE AnioMes = Par_FechaProceso
						AND ProductoCredID = Var_ProductoID
						LIMIT Aux_z, 1;


                        CALL EDOCTATIMBRADOCFDI(
							Var_RFCEmisor,				Var_RazonSocial,			Var_ExpCalle,				Var_ExpNumero,			Var_ExpColonia,
							Var_ExpMunicipio,			Var_ExpEstado,				Var_ExpCP,					Var_Tasa,				Var_NumIntEmisor,
							Var_NumExtEmisor,			Var_NumReg,					Var_CPEmisor,				Var_TimbraEdoCta,		Var_EstadoEmisor,
							Var_MuniEmisor,				Var_LocalEmisor,			Var_ColEmisor,				Var_CalleEmisor,		Var_GeneraCFDI,
							Var_AnioMes,				Var_SucursalID,				Var_NombreSucursalCte,		Var_ClienteID,			Var_NombreComple,
							Var_TipPer,					Var_TipoPersona,			Var_Calle,					Var_NumInt,				Var_NumExt,
							Var_Colonia,				Var_Estado,					Var_CodigoPostal,			Var_RFC,				Var_ISR,
							Var_FechaGeneracion,		Var_RegHacienda,			Var_ComisionAhorro,			Var_ComisionCredito,	Var_NombreInstitucion,
							Var_DireccionInstitucion,	Var_MunicipioDelegacion);


						SET Aux_z := Aux_z +1;
				END WHILE;
            END IF;
		END WHILE;

		SELECT '000' AS NumErr,
			'Proceso Finalizado Correctamente' AS ErrMen,
			Cadena_Vacia AS control,
			Entero_Cero AS consecutivo;
	ELSE
		SELECT '000' AS NumErr,
		'No se realiza el Timbrado por campo Timbrado Edo Cta.' AS ErrMen,
		Cadena_Vacia AS control,
		Entero_Cero AS consecutivo;
	END IF;

END$$