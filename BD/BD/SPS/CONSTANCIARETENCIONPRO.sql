-- SP CONSTANCIARETENCIONPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETENCIONPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETENCIONPRO`(
# ============================================================================
# ------ PROCESO PARA GENERAR INFORMACION DE CONSTANCIAS DE RETENCION --------
# ============================================================================
    Par_AnioMes 		INT(11),			-- Anio y Mes Constancia de Retencion

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
	DECLARE Var_Control     	VARCHAR(100);   -- Variable de control
	DECLARE Var_AnioStr     	VARCHAR(6);	 	-- Valor Anio
	DECLARE Var_FecInicial		DATE;		 	-- Fecha Inicial
	DECLARE Var_FecFinal		DATE;		 	-- Fecha Final
	DECLARE Var_AnioMesStr     	VARCHAR(6);		-- Anio y Mes

    DECLARE Var_FecIniMes   	DATE;			-- Fecha de Fin de mes
	DECLARE Var_FecFinMes   	DATE;			-- Fecha de FIn de mes
    DECLARE Var_Anio			INT(11);		-- Anio Proceso
	DECLARE Var_AnioMinimo	   	INT(11);		-- Anio Minimo
    DECLARE Var_AnioMaximo	    INT(11);		-- Anio Maximo
    DECLARE Var_NumAnio			INT(11);		-- NumAnio

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT;
	DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO		CHAR(1);
    DECLARE ValorUno		CHAR(2);
	DECLARE Cadena_Vacia 	CHAR(1);

    -- Asignacion de Constantes
    SET Entero_Cero			:= 0;			   -- Entero Cero
	SET Salida_SI			:= 'S';            -- Salida Store: SI
	SET Salida_NO        	:= 'N';            -- Salida Store: NO
	SET ValorUno			:= '01';		   -- Valor: 01
    SET Cadena_Vacia    	:= '';			   -- Cadena Vacia


    ManejoErrores:BEGIN     #bloque para manejar los posibles errores
     DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETENCIONPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Se obtiene el año y mes para generar informacion de la Constancia de Retencion
		SET Var_AnioMesStr := CAST(Par_AnioMes AS CHAR);

		-- Se obtiene la fecha inicial para generar informacion de la Constancia de Retencion
		SET Var_FecIniMes := DATE(CONCAT(Var_AnioMesStr,ValorUno));

		-- Se obtiente la fecha inicial del mes siguiente
		SET Var_FecFinMes := DATE_ADD(Var_FecIniMes,INTERVAL 1 MONTH);

		-- Se obtiene la fecha final para generar informacion de la Constancia de Retencion
		SET Var_FecFinMes := DATE_ADD(Var_FecFinMes,INTERVAL -1 DAY);

		-- Se obtiene el valor del Año
		SET Var_Anio := SUBSTRING(Par_AnioMes,1,4);

        -- Llamada a proceso para obtener los Intereses Pagados e ISR de Cuentas
		CALL CONSTANCIARETCTAPRO(
			Var_Anio,			MONTH(Var_FecIniMes),	Var_FecIniMes,		Var_FecFinMes,		Salida_NO,
            Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,  		Aud_Sucursal, 		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Llamada a proceso para obtener los Intereses Pagados e ISR de Inversiones
		CALL CONSTANCIARETINVPRO(
			Var_Anio,			MONTH(Var_FecIniMes),	Var_FecIniMes,		Var_FecFinMes,		Salida_NO,
            Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,  		Aud_Sucursal, 		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        -- Llamada a proceso para obtener los Intereses Pagados e ISR de CEDES
		CALL CONSTANCIARETCEDPRO(
			Var_Anio,			MONTH(Var_FecIniMes),	Var_FecIniMes,		Var_FecFinMes,		Salida_NO,
            Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,  		Aud_Sucursal, 		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

         -- Llamada a proceso para obtener los Intereses Pagados e ISR de Aportaciones
		CALL CONSTANCIARETAPORTAPRO(
			Var_Anio,			MONTH(Var_FecIniMes),	Var_FecIniMes,		Var_FecFinMes,		Salida_NO,
            Par_NumErr, 		Par_ErrMen, 			Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,  		Aud_Sucursal, 		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        -- Se valida si el Anio sean iguales
		IF(MONTH(Var_FecIniMes) = 12 AND MONTH(DATE_ADD(Var_FecIniMes,INTERVAL 1 MONTH)) = 1)THEN

			DELETE FROM CONSTANCIARETCTE WHERE Anio = YEAR(Var_FecIniMes) AND Mes = MONTH(Var_FecIniMes) - 1;

			   -- Llamada para obtener los Datos del Cliente
				CALL CONSTANCIARETCTEPRO(
					Var_Anio,			MONTH(Var_FecIniMes),	Salida_NO,			Par_NumErr, 		Par_ErrMen,
					Par_EmpresaID, 		Aud_Usuario, 			Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal, 		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE
				DELETE FROM CONSTANCIARETCTE WHERE Anio = YEAR(Var_FecIniMes);

			   -- Llamada para obtener los Datos del Cliente
				CALL CONSTANCIARETCTEPRO(
					Var_Anio,			MONTH(Var_FecIniMes),	Salida_NO,			Par_NumErr, 		Par_ErrMen,
					Par_EmpresaID, 		Aud_Usuario, 			Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal, 		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
        END IF;

        -- Se obtiene el Anio Minimo y Maximo
		SET Var_AnioMinimo := (SELECT MIN(Anio) FROM CONSTANCIARETENCION);
		SET Var_AnioMaximo := (SELECT MAX(Anio) FROM CONSTANCIARETENCION);

        SET Var_AnioMinimo := IFNULL(Var_AnioMinimo,Entero_Cero);
        SET Var_AnioMaximo := IFNULL(Var_AnioMaximo,Entero_Cero);

		SET Var_NumAnio := Var_AnioMaximo - Var_AnioMinimo;

        -- Se verifica el Numero de Anio para alamcenarlo en la tabla Historica
        IF(Var_NumAnio = 2)THEN

			INSERT INTO HISCONSTRETENCION(
					ClienteID,		Anio,				Mes,			TipoInstrumentoID,	InstrumentoID,
					Monto, 			InteresGravado,		InteresExento,	InteresRetener,		Ajuste,
					InteresReal,	EmpresaID,			Usuario, 		FechaActual,		DireccionIP,
					ProgramaID, 	Sucursal,			NumTransaccion)
            SELECT  ClienteID,		Anio,				Mes,			TipoInstrumentoID,	InstrumentoID,
					Monto, 			InteresGravado,		InteresExento,	InteresRetener,		Ajuste,
					InteresReal,	EmpresaID,			Usuario, 		FechaActual,		DireccionIP,
					ProgramaID, 	Sucursal,			NumTransaccion
            FROM CONSTANCIARETENCION
            WHERE Anio = Var_AnioMinimo;

            DELETE FROM CONSTANCIARETENCION WHERE Anio = Var_AnioMinimo;

            INSERT INTO HISCONSTANCIARETCTE(
					Anio,				Mes,				SucursalID,				NombreSucursalCte,		ClienteID,
					PrimerNombre, 		SegundoNombre,		TercerNombre, 			ApellidoPaterno,		ApellidoMaterno,
					NombreCompleto, 	RazonSocial,		TipoPersona,			RFC,					CURP,
					DireccionCompleta,	NombreInstitucion,	DireccionInstitucion,	FechaGeneracion,		RegHacienda,
					CadenaCFDI, 		CFDIFechaEmision, 	CFDIVersion, 			CFDINoCertSAT,			CFDIUUID,
					CFDIFechaTimbrado, 	CFDISelloCFD,		CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,
					CFDINoCertEmisor,	Estatus,			MontoTotOperacion,		MontoTotGrav, 			MontoTotExent,
					MontoTotRet, 		MontoIntReal, 		MontoCapital, 			EmpresaID, 				Usuario,
					FechaActual,		DireccionIP, 		ProgramaID, 			Sucursal,				NumTransaccion)
            SELECT 	Anio,				Mes,				SucursalID,				NombreSucursalCte,		ClienteID,
					PrimerNombre, 		SegundoNombre,		TercerNombre, 			ApellidoPaterno,		ApellidoMaterno,
					NombreCompleto, 	RazonSocial,		TipoPersona,			RFC,					CURP,
					DireccionCompleta,	NombreInstitucion,	DireccionInstitucion,	FechaGeneracion,		RegHacienda,
					CadenaCFDI, 		CFDIFechaEmision, 	CFDIVersion, 			CFDINoCertSAT,			CFDIUUID,
					CFDIFechaTimbrado, 	CFDISelloCFD,		CFDISelloSAT,			CFDICadenaOrig,			CFDIFechaCertifica,
					CFDINoCertEmisor,	Estatus,			MontoTotOperacion,		MontoTotGrav, 			MontoTotExent,
					MontoTotRet, 		MontoIntReal, 		MontoCapital, 			EmpresaID, 				Usuario,
					FechaActual,		DireccionIP, 		ProgramaID, 			Sucursal,				NumTransaccion
            FROM CONSTANCIARETCTE
			WHERE Anio = Var_AnioMinimo;

			DELETE FROM CONSTANCIARETCTE WHERE Anio = Var_AnioMinimo;

        END IF;

		SET Par_NumErr  	:= Entero_Cero;
		SET Par_ErrMen  	:= 'Proceso de Constancias de Retencion Finalizado Exitosamente.';
		SET Var_Control 	:= Cadena_Vacia;

    END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$