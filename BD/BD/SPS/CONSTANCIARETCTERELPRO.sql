-- SP CONSTANCIARETCTERELPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETCTERELPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCTERELPRO`(
# ============================================================================
# ----- PROCESO PARA OBTENER LOS DATOS DEL CLIENTE RELACIONADOS FISCALES  ----
# ============================================================================
	Par_Anio			INT(11),			-- Anio Constancia de Retencion
	Par_ClienteID		INT(11),			-- Numero de Cliente

    Par_Salida			CHAR(1),            -- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),			-- Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),  		-- Descripcion de Error

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control     		VARCHAR(100);   -- Variable de control
    DECLARE Var_ClienteID			INT(11);		-- Almacena el Numero de Cliente de la tabla RELACIONADOSFISCALES
    DECLARE Var_CteRelacionadoID	INT(11);		-- Almacena el Numero de Cliente Relacionado de la tabla RELACIONADOSFISCALES
	DECLARE Var_ParticipaFiscal		DECIMAL(14,2);	-- Almacena el % de Participacion Fiscal
    DECLARE Var_AnioMes				INT(11);		-- Almacena el valor del Anio y Mes

	DECLARE	Var_NombreInstit		VARCHAR(150);	-- Almacena el nombre de la institucion
	DECLARE	Var_DireccionInstit		VARCHAR(150);	-- Almacena la direccion de la institucion
	DECLARE	Var_NumInstitucion		INT(11);		-- Almacena el numero de la institucion
	DECLARE Var_SucursalID			INT(11);		-- Almacena el Numero de Sucursal del Cliente
	DECLARE Var_NombreSucurs		VARCHAR(60);	-- Almacena el Nombre de la Sucursal del Cliente

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	VARCHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE Decimal_Cero	DECIMAL(12,2);
	DECLARE Salida_SI       CHAR(1);

    DECLARE Salida_NO       CHAR(1);
	DECLARE EsRegHacienda	CHAR(1);
	DECLARE EsFiscal		CHAR(1);
    DECLARE EsOficial	    CHAR(1);
	DECLARE NoProcesado		INT(11);

    DECLARE Decimal_Cien	INT(11);
	DECLARE PersonaFisica	CHAR(1);
    DECLARE PersonaFisAct	CHAR(1);
	DECLARE PersonaMoral	CHAR(1);
	DECLARE TipoAportante	CHAR(1);

    DECLARE TipoCliente		CHAR(1);
    DECLARE TipoRelacion	CHAR(1);
	DECLARE TipoAportaCte	CHAR(2);
	DECLARE TipoCteAporta	CHAR(2);

	DECLARE Est_Pendiente	CHAR(1);
	DECLARE Est_Generado	CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
    SET Salida_SI			:= 'S';             -- Salida Store: SI

    SET Salida_NO        	:= 'N';             -- Salida Store: NO
	SET EsRegHacienda		:= 'S';				-- Registro Hacienda: SI
    SET EsFiscal		    := 'S';				-- Direccion Fiscal: SI
    SET EsOficial	    	:= 'S';				-- Direccion Oficial: SI
 	SET NoProcesado			:= 1; 				-- Numero No Procesado: 1

    SET Decimal_Cien		:= 100.00;			-- Decimal Cien
	SET PersonaFisica		:= 'F';				-- Tipo Persona: FISICA
    SET PersonaFisAct		:= 'A';				-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
	SET PersonaMoral		:= 'M';				-- Tipo Persona: MORAL
    SET TipoAportante		:= 'A';				-- Tipo Relacionado Fiscal: APORTANTE

    SET TipoCliente			:= 'C';				-- Tipo Relacionado Fiscal: CLIENTE
	SET TipoRelacion		:= 'R';				-- Tipo Relacionado Fiscal: RELACIONADO
    SET TipoAportaCte		:= 'AC';			-- Tipo Relacionado Fiscal: APORTANTE CLIENTE
    SET TipoCteAporta		:= 'CA';			-- Tipo Relacionado Fiscal: CLIENTE APORTANTE
    SET Est_Pendiente		:= 'P';				-- Estatus: Procesado

    SET Est_Generado		:= 'G';				-- Estatus: Generado

   ManejoErrores:BEGIN     #bloque para manejar los posibles errores
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
           BEGIN
              SET Par_NumErr  = 999;
              SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETCTERELPRO');
              SET Var_Control = 'SQLEXCEPTION';
		END;

        -- SE OBTIENE LA FECHA ACTUAL
		SET Aud_FechaActual := NOW();

        -- SE OBTIENE INFORMACION DEL APORTANTE Y LAS PERSONAS RELACIONADAS PRA GENERAR LA CONSTANCIA DE RETENCION
        IF NOT EXISTS (SELECT ClienteID FROM CONSTANCIARETCTEREL WHERE ClienteID = Par_ClienteID AND Anio = Par_Anio AND Tipo = TipoAportante)THEN

            -- SE OBTIENE LA INFORMACION DEL APORTANTE EN LA TABLA RELACIONADOSFISCALES
            SELECT 	ClienteID,		ParticipaFiscalCte
            INTO 	Var_ClienteID,	Var_ParticipaFiscal
            FROM RELACIONADOSFISCALES
            WHERE ClienteID = Par_ClienteID
            AND Ejercicio = Par_Anio LIMIT 1;

            -- SE OBTIENE EL APORTANTE RELACIONADO COMO CLIENTE EN LA TABLA RELACIONADOSFISCALES
            SELECT CteRelacionadoID
            INTO Var_CteRelacionadoID
            FROM RELACIONADOSFISCALES
            WHERE CteRelacionadoID > Entero_Cero
			AND TipoRelacionado = TipoCliente
            AND CteRelacionadoID = Par_ClienteID
            AND Ejercicio = Par_Anio LIMIT 1;

            SET Var_ClienteID 			:= IFNULL(Var_ClienteID,Entero_Cero);
            SET Var_ParticipaFiscal		:= IFNULL(Var_ParticipaFiscal,Decimal_Cero);
			SET Var_CteRelacionadoID 	:= IFNULL(Var_CteRelacionadoID,Entero_Cero);

			-- SE OBTIENE EL NUMERO DE LA INSTITUCION
			SET	Var_NumInstitucion	:= (SELECT InstitucionID FROM CONSTANCIARETPARAMS);
			SET	Var_NumInstitucion	:= IFNULL(Var_NumInstitucion, Entero_Cero);

			-- SE OBTIENE EL NOMBRE DE LA INSTITUCION
			SET Var_NombreInstit 	:= (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);
			SET	Var_NombreInstit	:= IFNULL(Var_NombreInstit, Cadena_Vacia);

			-- SE OBTIENE LA DIRECCION FISCAL DE LA INSTITUCION
			SET Var_DireccionInstit := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);
			SET	Var_DireccionInstit	:= IFNULL(Var_DireccionInstit, Cadena_Vacia);

            -- SE ASIGNA EL 100 % DE ASIGNACION DE PORCENTAJES EN CASO DE QUE NO EXISTA EL APORTANTE EN LA TABLA RELACIONADOSFISCALES
            IF(Var_ClienteID = Entero_Cero)THEN
				SET Var_ParticipaFiscal	:= Decimal_Cien;
            END IF;

			-- SE REGISTRA INFORMACION DEL CLIENTE EN LA TABLA CONSTANCIARETCTEREL
			INSERT INTO CONSTANCIARETCTEREL (
				Anio, 					AnioMes,				SucursalID,				NombreSucursalCte,		ClienteID,
                Tipo,					CteRelacionadoID,		PrimerNombre,			SegundoNombre,			TercerNombre,
                ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			RazonSocial, 			TipoPersona,
                RFC,  					CURP, 					DireccionCompleta, 		NombreInstitucion, 		DireccionInstitucion,
                FechaGeneracion, 		RegHacienda, 			Nacion,					PaisResidencia,			CadenaCFDI,
                CFDIFechaEmision,		CFDIVersion,			CFDINoCertSAT, 			CFDIUUID, 				CFDIFechaTimbrado,
                CFDISelloCFD, 			CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,		CFDINoCertEmisor,
                Estatus,				ParticipaFiscal,		MontoTotOperacion,		MontoTotGrav,			MontoTotExent,
                MontoTotRet,			MontoIntReal,			MontoCapital,			EstatusGenera,			EmpresaID,
                Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
                NumTransaccion)
			SELECT
				Par_Anio,				CONCAT(Con.Anio,Con.Mes),Cli.SucursalOrigen,		Con.NombreSucursalCte,	Con.ClienteID,
                TipoAportante,			Entero_Cero,			Cli.PrimerNombre,		Cli.SegundoNombre,		Cli.TercerNombre,
                Cli.ApellidoPaterno,	Cli.ApellidoMaterno,	Con.NombreCompleto,		Con.RazonSocial,		Con.TipoPersona,
                Cli.RFCOficial,			Cli.CURP,				Con.DireccionCompleta,	Con.NombreInstitucion,	Con.DireccionInstitucion,
                CURDATE(),				Cli.RegistroHacienda,	Cli.Nacion,				Cli.PaisResidencia,		Cadena_Vacia,
                Fecha_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                NoProcesado,			Var_ParticipaFiscal,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
                Decimal_Cero,			Decimal_Cero,		    Decimal_Cero,			Est_Pendiente,			Par_EmpresaID,
                Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
                Aud_NumTransaccion
			FROM  CLIENTES Cli,
				  CONSTANCIARETCTE Con
			WHERE Cli.ClienteID = Con.ClienteID
			AND Con.ClienteID = Par_ClienteID
			AND Con.Anio = Par_Anio;

            -- SE ACTUALIZA LA SUCURSAL ORIGEN DEL CLIENTE
			UPDATE CONSTANCIARETCTEREL Con,
				   SUCURSALES Suc
			SET Con.NombreSucursalCte = Suc.NombreSucurs
			WHERE Con.SucursalID = Suc.SucursalID
			AND Con.ClienteID = Par_ClienteID
			AND Con.Anio = Par_Anio;

            -- SE ACTUALIZA LA DIRECCION DEL CLIENTE
			UPDATE  CONSTANCIARETCTEREL Con,
					DIRECCLIENTE Dir
			SET Con.DireccionCompleta = Dir.DireccionCompleta
			WHERE Con.ClienteID	= Dir.ClienteID
			AND	CASE WHEN Con.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
			AND Con.ClienteID = Par_ClienteID
			AND Con.Anio = Par_Anio;

            -- SE ACTUALIZA LA DIRECCION OFICIAL DEL CLIENTE EN CASO DE NO TENER UNA DIRECCION FISCAL
			UPDATE CONSTANCIARETCTEREL Con,
				   DIRECCLIENTE Dir
			SET Con.DireccionCompleta = Dir.DireccionCompleta
			WHERE Con.ClienteID	= Dir.ClienteID
			AND	Con.DireccionCompleta = Cadena_Vacia
			AND Dir.Oficial = EsOficial
			AND Con.ClienteID = Par_ClienteID
			AND Con.Anio = Par_Anio;

			SELECT 	AnioMes,		SucursalID,		NombreSucursalCte
			INTO 	Var_AnioMes,	Var_SucursalID,	Var_NombreSucurs
			FROM CONSTANCIARETCTEREL
			WHERE ClienteID = Par_ClienteID
			AND Anio = Par_Anio LIMIT 1;

			-- ===================== INICIA OBTENCION DE INFORMACION DEL APORTANTE RELACIONADO COMO CLIENTE DE OTRO APORTANTE ============ --
            IF(Var_CteRelacionadoID != Entero_Cero)THEN
				-- SE VERIFICA SI NO SE HAYA REGISTRADO PREVIAMENTE EL APORTANTE RELACIONADO COMO CLIENTE DE OTRO APORTANTE
				IF NOT EXISTS (SELECT CteRelacionadoID FROM CONSTANCIARETCTEREL WHERE CteRelacionadoID = Par_ClienteID AND Anio = Par_Anio AND Tipo = TipoAportaCte)THEN
					INSERT INTO CONSTANCIARETCTEREL (
						Anio, 					AnioMes,				SucursalID,				NombreSucursalCte,		ClienteID,
						Tipo,					CteRelacionadoID,		PrimerNombre,			SegundoNombre,			TercerNombre,
						ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			RazonSocial, 			TipoPersona,
						RFC,  					CURP, 					DireccionCompleta, 		NombreInstitucion, 		DireccionInstitucion,
						FechaGeneracion, 		RegHacienda, 			Nacion,					PaisResidencia,			CadenaCFDI,
						CFDIFechaEmision,		CFDIVersion,			CFDINoCertSAT, 			CFDIUUID, 				CFDIFechaTimbrado,
						CFDISelloCFD, 			CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,		CFDINoCertEmisor,
						Estatus,				ParticipaFiscal,		MontoTotOperacion,		MontoTotGrav,			MontoTotExent,
						MontoTotRet,			MontoIntReal,			MontoCapital,			EstatusGenera,			EmpresaID,
						Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
						NumTransaccion)
					SELECT
						Par_Anio,				Var_AnioMes,			Cli.SucursalOrigen,		Cadena_Vacia,			Per.ClienteID,
						TipoAportaCte,			Per.CteRelacionadoID,	Cli.PrimerNombre,		Cli.SegundoNombre,		Cli.TercerNombre,
						Cli.ApellidoPaterno,	Cli.ApellidoMaterno,	CASE WHEN Cli.TipoPersona IN(PersonaFisica,PersonaFisAct) THEN Cli.NombreCompleto ELSE Cadena_Vacia END,
						CASE WHEN Cli.TipoPersona = PersonaMoral THEN Cli.RazonSocial ELSE Cadena_Vacia END,Cli.TipoPersona,
						Cli.RFCOficial,			Cli.CURP,				Cadena_Vacia,			Var_NombreInstit,		Var_DireccionInstit,
						CURDATE(),				Cli.RegistroHacienda,	Cli.Nacion,				Cli.PaisResidencia,		Cadena_Vacia,
                        Fecha_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                        Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                        NoProcesado,			Per.ParticipacionFiscal,Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
						Decimal_Cero,			Decimal_Cero,		    Decimal_Cero,			Est_Pendiente,			Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion
					FROM  CLIENTES Cli,
						  RELACIONADOSFISCALES Per
					WHERE Cli.ClienteID = Per.CteRelacionadoID
					AND Per.CteRelacionadoID > Entero_Cero
					AND Per.TipoRelacionado = TipoCliente
					AND Per.CteRelacionadoID = Par_ClienteID
					AND Per.Ejercicio = Par_Anio;

					-- SE ACTUALIZA LA SUCURSAL ORIGEN DEL CLIENTE
					UPDATE CONSTANCIARETCTEREL Con,
						   SUCURSALES Suc
					SET Con.NombreSucursalCte = Suc.NombreSucurs
					WHERE Con.SucursalID = Suc.SucursalID
					AND Con.Anio = Par_Anio;

					-- SE ACTUALIZA LA DIRECCION DEL CLIENTE
					UPDATE  CONSTANCIARETCTEREL Con,
							DIRECCLIENTE Dir
					SET Con.DireccionCompleta = Dir.DireccionCompleta
					WHERE Con.CteRelacionadoID	= Dir.ClienteID
					AND	CASE WHEN Con.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
					AND Con.Anio = Par_Anio;

					-- SE ACTUALIZA LA DIRECCION OFICIAL DEL CLIENTE EN CASO DE NO TENER UNA DIRECCION FISCAL
					UPDATE CONSTANCIARETCTEREL Con,
						   DIRECCLIENTE Dir
					SET Con.DireccionCompleta = Dir.DireccionCompleta
					WHERE Con.CteRelacionadoID	= Dir.ClienteID
					AND	Con.DireccionCompleta = Cadena_Vacia
					AND Dir.Oficial = EsOficial
					AND Con.Anio = Par_Anio;

                    -- SE ACTUALIZA A ESTATUS GENERADAO EN LA TABLA RELACIONADOS FISCALES
					UPDATE RELACIONADOSFISCALES Rel,
						   CONSTANCIARETCTEREL Con
					SET Rel.Estatus = Est_Generado
					WHERE Rel.CteRelacionadoID = Con.CteRelacionadoID
					AND Con.Tipo = TipoAportaCte
					AND Rel.ClienteID != Par_ClienteID
					AND Rel.Ejercicio = Par_Anio;

                END IF;
            END IF;
			-- ===================== FINALIZA OBTENCION DE INFORMACION DEL APORTANTE RELACIONADO COMO CLIENTE DE OTRO APORTANTE ============ --

            -- ===================== INICIA OBTENCION DE INFORMACION DE LAS PERSONAS RELACIONADAS DEL APORTANTE ========================== --
			IF(Var_ClienteID != Entero_Cero)THEN

				-- ====== SE OBTIENE INFORMACION DE LAS PERSONAS RELACIONADAS DEL APORTANTE CUANDO EL TIPO RELACIONADO NO ES CLIENTE ===== --
				INSERT INTO CONSTANCIARETCTEREL (
					Anio, 					AnioMes,				SucursalID,				NombreSucursalCte,		ClienteID,
					Tipo,					CteRelacionadoID,		PrimerNombre,			SegundoNombre,			TercerNombre,
					ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			RazonSocial, 			TipoPersona,
					RFC,  					CURP, 					DireccionCompleta, 		NombreInstitucion, 		DireccionInstitucion,
					FechaGeneracion, 		RegHacienda, 			Nacion,					PaisResidencia,			CadenaCFDI,
					CFDIFechaEmision,		CFDIVersion,			CFDINoCertSAT, 			CFDIUUID, 				CFDIFechaTimbrado,
					CFDISelloCFD, 			CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,		CFDINoCertEmisor,
					Estatus,				ParticipaFiscal,		MontoTotOperacion,		MontoTotGrav,			MontoTotExent,
					MontoTotRet,			MontoIntReal,			MontoCapital,			EstatusGenera,			EmpresaID,
					Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
					NumTransaccion)
				SELECT
					Par_Anio,				Var_AnioMes,			Var_SucursalID,			Var_NombreSucurs,		ClienteID,
                    TipoRelacion,			CteRelacionadoID,		PrimerNombre,			SegundoNombre,			TercerNombre,
                    ApellidoPaterno,		ApellidoMaterno,		FNGENNOMBRECOMPLETO(PrimerNombre, SegundoNombre,TercerNombre,ApellidoPaterno,ApellidoMaterno),Cadena_Vacia,TipoPersona,
                    RFC,					CURP,					DireccionCompleta,		Var_NombreInstit,		Var_DireccionInstit,
                    CURDATE(),				RegistroHacienda,		Nacion,					PaisResidencia,			Cadena_Vacia,
                    Fecha_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                    Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                    NoProcesado,			ParticipacionFiscal,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
					Decimal_Cero,			Decimal_Cero,		    Decimal_Cero,			Est_Pendiente,			Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion
				FROM  RELACIONADOSFISCALES
				WHERE CteRelacionadoID = Entero_Cero
                AND TipoRelacionado = TipoRelacion
				AND IFNULL(Estatus,Cadena_Vacia) = Est_Pendiente
				AND ClienteID = Var_ClienteID
				AND Ejercicio = Par_Anio;

				-- ====== SE OBTIENE INFORMACION DE LAS PERSONAS RELACIONADAS DEL APORTANTE CUANDO EL TIPO RELACIONADO ES CLIENTE ===== --
				INSERT INTO CONSTANCIARETCTEREL (
					Anio, 					AnioMes,				SucursalID,				NombreSucursalCte,		ClienteID,
					Tipo,					CteRelacionadoID,		PrimerNombre,			SegundoNombre,			TercerNombre,
					ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			RazonSocial, 			TipoPersona,
					RFC,  					CURP, 					DireccionCompleta, 		NombreInstitucion, 		DireccionInstitucion,
					FechaGeneracion, 		RegHacienda, 			Nacion,					PaisResidencia,			CadenaCFDI,
					CFDIFechaEmision,		CFDIVersion,			CFDINoCertSAT, 			CFDIUUID, 				CFDIFechaTimbrado,
					CFDISelloCFD, 			CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,		CFDINoCertEmisor,
					Estatus,				ParticipaFiscal,		MontoTotOperacion,		MontoTotGrav,			MontoTotExent,
					MontoTotRet,			MontoIntReal,			MontoCapital,			EstatusGenera,			EmpresaID,
					Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
					NumTransaccion)
				SELECT
					Par_Anio,				Var_AnioMes,			Cli.SucursalOrigen,		Cadena_Vacia,			Per.ClienteID,
                    TipoCliente,			Per.CteRelacionadoID,	Cli.PrimerNombre,		Cli.SegundoNombre,		Cli.TercerNombre,
                    Cli.ApellidoPaterno,	Cli.ApellidoMaterno,	CASE WHEN Cli.TipoPersona IN(PersonaFisica,PersonaFisAct) THEN Cli.NombreCompleto ELSE Cadena_Vacia END,
                    CASE WHEN Cli.TipoPersona = PersonaMoral THEN Cli.RazonSocial ELSE Cadena_Vacia END,Cli.TipoPersona,
                    Cli.RFCOficial,			Cli.CURP,				Cadena_Vacia,			Var_NombreInstit,		Var_DireccionInstit,
                    CURDATE(),				Cli.RegistroHacienda,	Cli.Nacion,				Cli.PaisResidencia,		Cadena_Vacia,
                    Fecha_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                    Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
                    NoProcesado,			Per.ParticipacionFiscal,Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
                    Decimal_Cero,			Decimal_Cero,		    Decimal_Cero,			Est_Pendiente,			Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion
				FROM  CLIENTES Cli,
					  RELACIONADOSFISCALES Per
				WHERE Cli.ClienteID = Per.CteRelacionadoID
                AND Per.TipoRelacionado = TipoCliente
                AND IFNULL(Per.Estatus,Cadena_Vacia) = Est_Pendiente
				AND Per.ClienteID = Var_ClienteID
				AND Per.Ejercicio = Par_Anio;


				-- SE ACTUALIZA LA SUCURSAL ORIGEN DEL CLIENTE
				UPDATE CONSTANCIARETCTEREL Con,
					   SUCURSALES Suc
				SET Con.NombreSucursalCte = Suc.NombreSucurs
				WHERE Con.SucursalID = Suc.SucursalID
				AND Con.Anio = Par_Anio;

                -- SE ACTUALIZA LA DIRECCION DEL CLIENTE
				UPDATE  CONSTANCIARETCTEREL Con,
						DIRECCLIENTE Dir
				SET Con.DireccionCompleta = Dir.DireccionCompleta
				WHERE Con.CteRelacionadoID	= Dir.ClienteID
				AND	CASE WHEN Con.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
				AND Con.Anio = Par_Anio;

				-- SE ACTUALIZA LA DIRECCION OFICIAL DEL CLIENTE EN CASO DE NO TENER UNA DIRECCION FISCAL
				UPDATE CONSTANCIARETCTEREL Con,
					   DIRECCLIENTE Dir
				SET Con.DireccionCompleta = Dir.DireccionCompleta
				WHERE Con.CteRelacionadoID	= Dir.ClienteID
				AND	Con.DireccionCompleta = Cadena_Vacia
				AND Dir.Oficial = EsOficial
				AND Con.Anio = Par_Anio;

                -- SE ACTUALIZA EL TIPO DE APORTANTE COMO CLIENTE CUANDO EL CLIENTE RELACIONADO HAYA GENERADO INSTERESES EN EL PERIODO
				UPDATE CONSTANCIARETCTEREL Con,
					CONSTANCIARETCTE Cte
				SET Con.Tipo = TipoAportaCte
				WHERE Con.CteRelacionadoID = Cte.ClienteID
				AND Con.ClienteID = Par_ClienteID
				AND Con.Anio = Par_Anio;

				-- SE ACTUALIZA A ESTATUS GENERADAO EN LA TABLA RELACIONADOS FISCALES
				UPDATE RELACIONADOSFISCALES Rel,
					   CONSTANCIARETCTEREL Con
				SET Rel.Estatus = Est_Generado
				WHERE Rel.CteRelacionadoID = Con.CteRelacionadoID
				AND Rel.ClienteID = Par_ClienteID
				AND Rel.Ejercicio = Par_Anio;


			END IF;
			-- ===================== FINALIZA OBTENCION DE INFORMACION DE LAS PERSONAS RELACIONADAS DEL APORTANTE ========================== --

            -- ===================== INICIA OBTENCION DE INFORMACION DE LOS CLIENTES RELACIONADOS QUE SE ENCUENTREN RELACIONADOS CON OTROS APORTANTES ===== --

			-- SE ELIMINA LA TABLA TEMPORAL
			DELETE FROM TMPCTERELAPORTANTE;

            INSERT INTO TMPCTERELAPORTANTE(
				ClienteID,		EmpresaID,		Usuario,		FechaActual,		DireccionIP,
                ProgramaID,		Sucursal,		NumTransaccion)
            SELECT
				CteRelacionadoID, Par_EmpresaID, 	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion
			FROM RELACIONADOSFISCALES
			WHERE ClienteID = Par_ClienteID
			AND Ejercicio = Par_Anio
			AND Estatus = Est_Generado
            AND TipoRelacionado = TipoCliente;


			INSERT INTO CONSTANCIARETCTEREL (
				Anio, 					AnioMes,				SucursalID,				NombreSucursalCte,		ClienteID,
				Tipo,					CteRelacionadoID,		PrimerNombre,			SegundoNombre,			TercerNombre,
				ApellidoPaterno,		ApellidoMaterno,		NombreCompleto,			RazonSocial, 			TipoPersona,
				RFC,  					CURP, 					DireccionCompleta, 		NombreInstitucion, 		DireccionInstitucion,
				FechaGeneracion, 		RegHacienda, 			Nacion,					PaisResidencia,			CadenaCFDI,
				CFDIFechaEmision,		CFDIVersion,			CFDINoCertSAT, 			CFDIUUID, 				CFDIFechaTimbrado,
				CFDISelloCFD, 			CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,		CFDINoCertEmisor,
				Estatus,				ParticipaFiscal,		MontoTotOperacion,		MontoTotGrav,			MontoTotExent,
				MontoTotRet,			MontoIntReal,			MontoCapital,			EstatusGenera,			EmpresaID,
				Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
				NumTransaccion)
			SELECT
				Par_Anio,				Var_AnioMes,			Cli.SucursalOrigen,		Cadena_Vacia,			Rel.ClienteID,
				TipoCliente,			Rel.CteRelacionadoID,	Cli.PrimerNombre,		Cli.SegundoNombre,		Cli.TercerNombre,
				Cli.ApellidoPaterno,	Cli.ApellidoMaterno,	CASE WHEN Cli.TipoPersona IN(PersonaFisica,PersonaFisAct) THEN Cli.NombreCompleto ELSE Cadena_Vacia END,
				CASE WHEN Cli.TipoPersona = PersonaMoral THEN Cli.RazonSocial ELSE Cadena_Vacia END,Cli.TipoPersona,
				Cli.RFCOficial,			Cli.CURP,				Cadena_Vacia,			Var_NombreInstit,		Var_DireccionInstit,
				CURDATE(),				Cli.RegistroHacienda,	Cli.Nacion,				Cli.PaisResidencia,		Cadena_Vacia,
				Fecha_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
				Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
				NoProcesado,			Rel.ParticipacionFiscal,Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
				Decimal_Cero,			Decimal_Cero,		    Decimal_Cero,			Est_Pendiente,			Par_EmpresaID,
                Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
                Aud_NumTransaccion
			FROM  CLIENTES Cli,
				  TMPCTERELAPORTANTE Per,
                  RELACIONADOSFISCALES Rel
			WHERE Per.ClienteID = Rel.CteRelacionadoID
			AND  Rel.CteRelacionadoID = Cli.ClienteID
			AND IFNULL(Rel.Estatus,Cadena_Vacia) = Est_Pendiente
			AND Rel.ClienteID != Var_ClienteID
			AND Rel.Ejercicio = Par_Anio;

            -- SE ACTUALIZA A ESTATUS GENERADAO EN LA TABLA RELACIONADOS FISCALES
			UPDATE TMPCTERELAPORTANTE Per,
                   RELACIONADOSFISCALES Rel
			SET Rel.Estatus = Est_Generado
			WHERE Per.ClienteID = Rel.CteRelacionadoID
			AND IFNULL(Rel.Estatus,Cadena_Vacia) = Est_Pendiente
			AND Rel.ClienteID != Var_ClienteID
			AND Rel.Ejercicio = Par_Anio;

            -- SE ACTUALIZA LA SUCURSAL ORIGEN DEL CLIENTE
			UPDATE CONSTANCIARETCTEREL Con,
				   SUCURSALES Suc
			SET Con.NombreSucursalCte = Suc.NombreSucurs
			WHERE Con.SucursalID = Suc.SucursalID
			AND Con.Anio = Par_Anio;

			-- SE ACTUALIZA LA DIRECCION DEL CLIENTE
			UPDATE  CONSTANCIARETCTEREL Con,
					DIRECCLIENTE Dir
			SET Con.DireccionCompleta = Dir.DireccionCompleta
			WHERE Con.CteRelacionadoID	= Dir.ClienteID
			AND	CASE WHEN Con.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
			AND Con.Anio = Par_Anio;

			-- SE ACTUALIZA LA DIRECCION OFICIAL DEL CLIENTE EN CASO DE NO TENER UNA DIRECCION FISCAL
			UPDATE CONSTANCIARETCTEREL Con,
				   DIRECCLIENTE Dir
			SET Con.DireccionCompleta = Dir.DireccionCompleta
			WHERE Con.CteRelacionadoID	= Dir.ClienteID
			AND	Con.DireccionCompleta = Cadena_Vacia
			AND Dir.Oficial = EsOficial
			AND Con.Anio = Par_Anio;

			-- ===================== FINALIZA OBTENCION DE INFORMACION DE LOS CLIENTES RELACIONADOS QUE SE ENCUENTREN RELACIONADOS CON OTROS APORTANTES ===== --

		END IF;

		SET Par_NumErr  	:= Entero_Cero;
		SET Par_ErrMen  	:= 'Proceso para Obtener Informacion de los Clientes Relacionados Fiscales Finalizado Exitosamente.';
		SET Var_Control 	:= Cadena_Vacia;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$