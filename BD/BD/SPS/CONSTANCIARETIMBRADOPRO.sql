-- SP CONSTANCIARETIMBRADOPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETIMBRADOPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETIMBRADOPRO`(
	-- SP creado para obtener informacion necesaria para el timbrado de la Constancia de Retencion
	Par_AnioProceso 	INT(11), 		-- Anio de Proceso Constancia de Retencion
	Par_SucursalInicio	INT(11),		-- Sucursal de Inicio
	Par_SucursalFin		INT(11),		-- Sucursal Fin
	Par_ClienteID		INT(11),		-- Numero de Cliente

	Par_Salida			CHAR(1), 		-- Indica si espera un SELECT de salida
	INOUT Par_NumErr 	INT(11),		-- Numero de Error
	INOUT Par_ErrMen 	VARCHAR(400), 	-- Descripcion de Error

	Par_EmpresaID		INT(11),		-- Parametro de Auditoria
	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control 		VARCHAR(100); 			-- Variable de control
    DECLARE Var_Anio            INT(11);				-- Anio del proceso
    DECLARE Var_ClienteID       INT(11);				-- Numero de Cliente
    DECLARE Var_NombreComple    VARCHAR(250);			-- Nombre Completo del Cliente
    DECLARE Var_TipoPersona     CHAR(1);				-- Tipo de Persona: FISICA, MORAL

    DECLARE Var_RFC             VARCHAR(20);			-- RFC del cliente
    DECLARE Var_RazonSocial     VARCHAR(100);			-- Razon Social de la empresa
    DECLARE Var_RFCEmisor       VARCHAR(25);			-- RFC del emisor
    DECLARE Var_GeneraCFDI      CHAR(1);				-- Valor si genera CFD
    DECLARE Var_RegHacienda     CHAR(1);				-- Valor del Registro en Hacienda

    DECLARE Var_TimbraConsRet 	CHAR(1);				-- Valor del Timbrado de Constancia de Retencion
    DECLARE Var_ErrorKey      	INT DEFAULT 0;			-- Claves de errores en el cursor
    DECLARE Var_ClienteStr  	VARCHAR(20); 			-- Numero de cliente para el control de errores en el cursor
    DECLARE Var_FechaSistema	DATE;					-- Fecha del Sistema
	DECLARE ProTimbraConsRet	INT(11);				-- Numero de Proceso Timbrado Constancia Retencion

    DECLARE Var_CliProEsp   	INT(11);				-- Almacena el Numero de Cliente para Procesos Especificos
    DECLARE Var_ConsecutivoID	INT(11);   				-- Variable consecutivo
	DECLARE Var_NumRegistros	INT(11);				-- Almacena el Numero de Registros
	DECLARE Var_Contador		INT(11);				-- Contador

	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT(11);
	DECLARE Decimal_Cero 		DECIMAL(12,2);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);

    DECLARE PersonaFisica		CHAR(1);
	DECLARE TimbraConsRetSI		CHAR(1);
    DECLARE ErrorUno            VARCHAR(400);
	DECLARE ErrorDos            VARCHAR(400);
    DECLARE ErrorTres           VARCHAR(400);

    DECLARE ErrorCuatro         VARCHAR(400);
    DECLARE TimbradoConsRet		VARCHAR(50);
    DECLARE ValorNO				CHAR(1);
    DECLARE Con_CliProcEspe     VARCHAR(20);
    DECLARE NumClienteMexi		INT(11);

	DECLARE PersonaFisAct		CHAR(1);
	DECLARE TipoAportante		CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero 		:= 0;			-- Entero Cero
	SET Decimal_Cero 		:= 0.0;			-- Decimal Cero
	SET Cadena_Vacia 		:= '';			-- Cadena Vacia
	SET Salida_SI			:= 'S'; 		-- Salida Store: SI
	SET Salida_NO 			:= 'N'; 		-- Salida Store: NO

    SET PersonaFisica		:= 'F';			-- Tipo Persona: FISICA
    SET	TimbraConsRetSI		:= 'S';			-- Timbrado Constancia Retencion: SI
	SET ErrorUno    		:= 'ERROR DE SQL GENERAL';
	SET ErrorDos    		:= 'ERROR EN ALTA, LLAVE DUPLICADA';
    SET ErrorTres   		:= 'ERROR AL LLAMAR A STORE PROCEDURE';

    SET ErrorCuatro  		:= 'ERROR VALORES NULOS';
    SET TimbradoConsRet		:= 'CONSTANCIARETIMBRADOPRO';
    SET ValorNO				:= 'N';			-- Valor: NO
    SET Con_CliProcEspe     := 'CliProcEspecifico'; -- Llave Parametro para Procesos Especificos
	SET NumClienteMexi		:= 40;			-- Numero de Cliente para Mexi Procesos Especificos: 40

	SET PersonaFisAct		:= 'A';			-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
	SET TipoAportante		:= 'A';			-- Tipo Relacionado Fiscal: APORTANTE

	ManejoErrores:BEGIN #bloque para manejar los posibles errores
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETIMBRADOPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Se obtiene el Numero de Cliente para Procesos Especificos
		SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
		SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

		-- Se obtiene el numero de proceso del timbrado de constancia de retencion
		SET ProTimbraConsRet	:= (SELECT ProcesoBatchID FROM PROCESOSBATCH WHERE NombreRutina = TimbradoConsRet LIMIT 1);
		SET ProTimbraConsRet	:= IFNULL(ProTimbraConsRet,Entero_Cero);

		-- Se obtiene los datos de la Institucion
		SELECT  Con.TimbraConsRet,	Ins.Nombre,			Ins.RFC, 			Par.GeneraCFDINoReg,
				Par.FechaSistema
		INTO 	Var_TimbraConsRet,	Var_RazonSocial,	Var_RFCEmisor, 		Var_GeneraCFDI,
				Var_FechaSistema
		FROM CONSTANCIARETPARAMS Con
		INNER JOIN PARAMETROSSIS Par ON Con.InstitucionID = Par.InstitucionID
		INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID;

		SET Var_TimbraConsRet 	:= IFNULL(Var_TimbraConsRet,Salida_NO);
		SET Var_RazonSocial 	:= IFNULL(Var_RazonSocial,Cadena_Vacia);
		SET Var_RFCEmisor 		:= IFNULL(Var_RFCEmisor,Cadena_Vacia);
		SET Var_GeneraCFDI 		:= IFNULL(Var_GeneraCFDI,Cadena_Vacia);

		-- Se realiza el timbrado de la Constancia de Retencion para un cliente en especifico
		IF (Par_ClienteID != Entero_Cero)THEN
			-- Se genera Constancia de Retencion para clientes diferente a MEXI
			IF(Var_CliProEsp != NumClienteMexi)THEN
				SELECT  Anio,		ClienteID,	 	TipoPersona,		RFC,		RegHacienda,
						CASE WHEN TipoPersona = PersonaFisica THEN NombreCompleto ELSE RazonSocial END
				INTO	Var_Anio,	Var_ClienteID,	Var_TipoPersona,	Var_RFC,    Var_RegHacienda,
						Var_NombreComple
				FROM CONSTANCIARETCTE
				WHERE Anio = Par_AnioProceso AND ClienteID = Par_ClienteID;

				-- Llamada para el armado de la cadena CFDI para el timbrado de la Constancia de Retencion
				CALL CONSTANCIARETIMBRADOCFDIPRO(
					Var_RFCEmisor,			Var_RazonSocial,		Var_GeneraCFDI,			Var_Anio,				Var_ClienteID,
					Var_NombreComple,		Var_TipoPersona,		Var_RFC,				Var_RegHacienda,		Decimal_Cero,
                    Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Cadena_Vacia,			Cadena_Vacia,
                    Entero_Cero,			Salida_NO,				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,
                    Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,  		Aud_Sucursal,
                    Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

            -- Se genera Informacion para la Constancia de Retencion para MEXI
            IF(Var_CliProEsp = NumClienteMexi)THEN
				-- Se llama al Proceso para el registro de los RELACIONADOS FISCALES para generar la Constancia de Retencion
                CALL CONSTANCIARETCTERELPRO (
					Par_AnioProceso,		Par_ClienteID, 			Salida_NO,				Par_NumErr, 			Par_ErrMen,
                    Par_EmpresaID, 			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
                    Aud_Sucursal, 			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

                -- Se obtiene informacion del Cliente Relacionado
                SELECT  Anio,		ClienteID
				INTO	Var_Anio,	Var_ClienteID
				FROM CONSTANCIARETCTEREL
				WHERE Anio = Par_AnioProceso
                AND ClienteID = Par_ClienteID
				AND Tipo = TipoAportante;

               -- Llamada al proceso para la distribucion de Intereses y Retenciones para el timbrado de la Constancia de Retencion del Relacionado Fiscal
				CALL CONSTANCIARETRELTIMBRADOPRO(
					Var_RFCEmisor,			Var_RazonSocial,		Var_GeneraCFDI,			Var_Anio,				Var_ClienteID,
					Salida_NO,				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID, 			Aud_Usuario,
                    Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,  		Aud_Sucursal, 			Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

            END IF;

		END IF;

		-- Se realiza el timbrado masivo de los estados de Constancias de los clientes
		IF (Par_ClienteID = Entero_Cero)THEN
			-- Se elimina la tabla temporal
			DELETE FROM TMPCONSTANCIARETCTE;
			SET @Var_ConsecutivoID := 0;

			-- Se obtiene informacion de Constancias de Retencion por Sucursales
			INSERT INTO TMPCONSTANCIARETCTE(
				ConsecutivoID,		Anio,				ClienteID,			TipoPersona,		RFC,
				RegHacienda,   		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
				DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

			SELECT
				@Var_ConsecutivoID:=@Var_ConsecutivoID+1,	Anio,	ClienteID,	TipoPersona,  		RFC,
				RegHacienda, CASE WHEN TipoPersona IN(PersonaFisica,PersonaFisAct) THEN NombreCompleto ELSE RazonSocial END,
				Par_EmpresaID, 		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion
			FROM CONSTANCIARETCTE
			WHERE Anio = Par_AnioProceso AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;

			-- Se obtiene el Numero de Registros de Constancias de Retencion por Sucursales
			SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCONSTANCIARETCTE);
			SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

			-- Se valida que el Numero de Registros de Constancias de Retencion sea Mayor a Cero
			IF(Var_NumRegistros > Entero_Cero)THEN
				-- Se inicaliza el contador
				SET Var_Contador := 1;

				-- Se generan las Constancias de Retencion por Sucursales
				WHILE(Var_Contador <= Var_NumRegistros) DO
					SELECT	Anio,		ClienteID,		TipoPersona,		RFC,		RegHacienda,
							NombreCompleto
					INTO    Var_Anio,	Var_ClienteID,	Var_TipoPersona, 	Var_RFC,	Var_RegHacienda,
							Var_NombreComple
					FROM TMPCONSTANCIARETCTE
					WHERE ConsecutivoID = Var_Contador;

					-- Se genera Constancia de Retencion para clientes diferente a MEXI
					IF(Var_CliProEsp != NumClienteMexi)THEN
						-- Llamada para el armado de la cadena CFDI para el timbrado de la Constancia de Retencion
						CALL CONSTANCIARETIMBRADOCFDIPRO(
							Var_RFCEmisor,			Var_RazonSocial,		Var_GeneraCFDI,			Var_Anio,				Var_ClienteID,
							Var_NombreComple,		Var_TipoPersona,		Var_RFC,				Var_RegHacienda,		Decimal_Cero,
                            Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Cadena_Vacia,			Cadena_Vacia,
							Entero_Cero,			Salida_NO,				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,
                            Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,  		Aud_Sucursal,
                            Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;  -- FIN Se genera Constancia de Retencion para clientes diferente a MEXI

					 -- Se genera informacion para la Constancia de Retencion para MEXI
					IF(Var_CliProEsp = NumClienteMexi)THEN
						-- Se llama al Proceso para el registro de los RELACIONADOS FISCALES para generar la Constancia de Retencion
						CALL CONSTANCIARETCTERELPRO (
							Var_Anio,				Var_ClienteID, 			Salida_NO,				Par_NumErr, 			Par_ErrMen,
							Par_EmpresaID, 			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
							Aud_Sucursal, 			Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;

					SET Var_Contador := Var_Contador + 1;

				END WHILE; -- FIN del WHILE

			END IF; -- FIN Se valida que el Numero de Registros de Constancias de Retencion sea Mayor a Cero

		END IF;

		-- Se genera Constancia de Retencion para MEXI
		IF(Par_ClienteID = Entero_Cero AND Var_CliProEsp = NumClienteMexi)THEN

			-- Se elimina la tabla temporal
			DELETE FROM TMPCONSTANCIARETCTE;
			SET @Var_ConsecutivoID := 0;

			-- Se obtiene informacion de Constancias de Retencion por Sucursales
			INSERT INTO TMPCONSTANCIARETCTE(
				ConsecutivoID,		Anio,				ClienteID,			TipoPersona,		RFC,
				RegHacienda,   		NombreCompleto,		EmpresaID,			Usuario,			FechaActual,
				DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)

			SELECT
				@Var_ConsecutivoID:=@Var_ConsecutivoID+1,	Anio,	ClienteID,	Cadena_Vacia,  	Cadena_Vacia,
				Cadena_Vacia,		Cadena_Vacia,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
			FROM CONSTANCIARETCTEREL
			WHERE Anio = Par_AnioProceso
            AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
            AND Tipo = TipoAportante;

			-- Se obtiene el Numero de Registros de Constancias de Retencion por Sucursales
			SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCONSTANCIARETCTE);
			SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

			-- Se valida que el Numero de Registros de Constancias de Retencion sea Mayor a Cero
			IF(Var_NumRegistros > Entero_Cero)THEN
				-- Se inicaliza el contador
				SET Var_Contador := 1;

				-- Se generan las Constancias de Retencion por Sucursales
				WHILE(Var_Contador <= Var_NumRegistros) DO
					SELECT	Anio,		ClienteID
					INTO    Var_Anio,	Var_ClienteID
					FROM TMPCONSTANCIARETCTE
					WHERE ConsecutivoID = Var_Contador;

					-- Llamada al proceso para la distribucion de Intereses y Retenciones para el timbrado de la Constancia de Retencion del Relacionado Fiscal
					CALL CONSTANCIARETRELTIMBRADOPRO(
						Var_RFCEmisor,			Var_RazonSocial,		Var_GeneraCFDI,			Var_Anio,				Var_ClienteID,
						Salida_NO,				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID, 			Aud_Usuario,
                        Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,  		Aud_Sucursal, 			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_Contador := Var_Contador + 1;

				END WHILE; -- FIN del WHILE

			END IF; -- FIN Se valida que el Numero de Registros de Constancias de Retencion sea Mayor a Cero

		END IF; -- FIN Se genera Constancia de Retencion para MEXI

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Timbrado Constancia Retencion Realizado Exitosamente.';
		SET Var_Control 	:= 'procesar';

		IF(Var_TimbraConsRet = ValorNO)THEN
			SET Par_NumErr 		:= Entero_Cero;
			SET Par_ErrMen 		:= 'No se realiza el Timbrado por campo Timbrado Constancia Retencion';
			SET Var_Control 	:= 'procesar';
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		 SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$