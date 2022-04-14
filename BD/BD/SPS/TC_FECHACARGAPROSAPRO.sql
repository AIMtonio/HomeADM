-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_FECHACARGAPROSAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_FECHACARGAPROSAPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_FECHACARGAPROSAPRO`(
-- ---------------------------------------------------------------------------------
-- Valida si continua el proceso del cron job
-- ---------------------------------------------------------------------------------
    Par_FechaEjec 			DATE,				-- Fecha de ejecucion del cron job
    Par_Estatus				CHAR(1),			-- Estatus de la ejecución
    Par_TipoArchivo			CHAR(1),			-- Tipo archivo a cargar S= STATS, E= EMI
    Par_HoraEjecucion		TIME,				-- Hora en la que se realizo el intento de carga de archivo ya sea exitoso o no
    Par_NumPro				TINYINT UNSIGNED,	-- Nunero de proceso

    Par_Salida              CHAR(1),			-- Salida
    INOUT Par_NumErr        INT(11),			-- Salida
    INOUT Par_ErrMen        VARCHAR(400),  		-- Salida

    Aud_EmpresaID           INT(11),			-- Auditoria
    Aud_Usuario             INT(11),			-- Auditoria
    Aud_FechaActual         DATETIME,		 	-- Auditoria
    Aud_DireccionIP         VARCHAR(15),   		-- Auditoria
    Aud_ProgramaID          VARCHAR(50),   		-- Auditoria
    Aud_Sucursal            INT(11),			-- Auditoria
    Aud_NumTransaccion      BIGINT(20)		 	-- Auditoria

)
TerminaStore:BEGIN
	-- Constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(1);			-- Constante entero cero
	DECLARE Cadena_Vacia		VARCHAR(2);		-- Constante Cadena vacia
	DECLARE Estatus_Exito		CHAR(1);		-- Estatus del documento exito
	DECLARE Estatus_Fallido		CHAR(1);		-- Estatus del documento fallido
	DECLARE Entero_Uno			INT(1);			-- Constante entero uno
	DECLARE Pro_Principal		INT(1);			-- Proceso principal
	DECLARE Pro_Reseteo			INT(1);			-- Proceso para reseteo
	DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
	-- Variables
	DECLARE Var_Estatus			CHAR(1);		-- Estatus de la cola de ejecucion
	DECLARE Var_IntentosF		INT(11);		-- Intentos fallidos de lectura
	DECLARE Var_Fecha			DATE;			-- Fecha de la ejecucion
	DECLARE Var_FCargaProsaID	BIGINT(20);		-- Fecha de la ejecucion
    DECLARE Var_ContFallidos	INT(11);		-- Contador de intentos fallidos
	
	
	
	-- Asignacion de constantes
	SET Fecha_Vacia     := '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 	:= 0;				-- Asignacion a entero cero
	SET Entero_Uno		:= 1;				-- Asignacion a entero uno
	SET Cadena_Vacia	:= '';				-- Asifnacion a cadena vacia
	SET Pro_Principal	:= 1;				-- Proceso principal
	SET Pro_Reseteo		:= 2;				-- Proceso reseteo
	
	SET Estatus_Exito		:= 'E';		-- Asignacion estatus de Exito
	SET Estatus_Fallido		:= 'F';		-- Asignación estatus Fallido
	SET Salida_SI			:= 'S';		-- SALIDA SI
    SET Var_ContFallidos	:= 0;		-- Contador de fallidos
    SET Var_FCargaProsaID	:= 0;		-- Var id de la fecha
	
	
ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_FECHACARGAPROSAPRO');
      END;
      IF(Par_NumPro = Pro_Principal ) THEN
		-- Verificar la existencia de la ejecucion
		SELECT 		FechaCargaProsaID,		Fecha, 			IntentosFallidos,		Estatus
			INTO	Var_FCargaProsaID,		Var_Fecha,		Var_ContFallidos,		Var_Estatus
			FROM TC_FECHACARGAPROSA 
			WHERE Fecha = Par_FechaEjec AND TipoArchivo = Par_TipoArchivo;
			
		IF(Var_Estatus = Estatus_Exito) THEN
			SET Par_NumErr:= 1;
			SET Par_ErrMen:= CONCAT('No se puede actualizar un archivo procesado (', Var_FCargaProsaID, ').');
		END IF;

		-- Si no existe el registro lo insertamos
		IF (IFNULL(Var_FCargaProsaID, Entero_Cero)  = Entero_Cero ) THEN
				IF(Par_Estatus = Estatus_Fallido) THEN
					-- Genera ID
					CALL FOLIOSAPLICAACT('TC_FECHACARGAPROSA', Var_FCargaProsaID);
					
					INSERT INTO TC_FECHACARGAPROSA( 
							FechaCargaProsaID,		TipoArchivo,			Fecha,				IntentosFallidos,		Estatus,	
							HoraEjecucion,			EmpresaID,				Usuario,			FechaActual,			DireccionIP,		
							ProgramaID,				Sucursal,				NumTransaccion
						)
						VALUES(
							Var_FCargaProsaID,		Par_TipoArchivo,		Par_FechaEjec,		Entero_Uno,				Par_Estatus,
							Par_HoraEjecucion,		Aud_EmpresaID,			Aud_Usuario, 		Aud_FechaActual,    	Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
						);
				END IF;
				-- Estatus exitoso
				IF(Par_Estatus = Estatus_Exito) THEN
					CALL FOLIOSAPLICAACT('TC_FECHACARGAPROSA', Var_FCargaProsaID);
	
					INSERT INTO TC_FECHACARGAPROSA( 
							FechaCargaProsaID,		TipoArchivo,			Fecha,				IntentosFallidos,	Estatus,	
							HoraEjecucion,			EmpresaID,				Usuario,			FechaActual,		DireccionIP,
							ProgramaID,				Sucursal,				NumTransaccion
						)
						VALUES(
							Var_FCargaProsaID,		Par_TipoArchivo,		Par_FechaEjec,		Entero_Cero,		Par_Estatus,
							Par_HoraEjecucion,		Aud_EmpresaID,			Aud_Usuario, 		Aud_FechaActual,    Aud_DireccionIP,
							Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
						);
				END IF;
				
					
		END IF;
			
		-- En caso de existir el registro lo actualizamos
		IF (Var_FCargaProsaID <> Entero_Cero) THEN
				-- Se suma el intento fallido
				IF(Par_Estatus = Estatus_Fallido) THEN
					SET Var_ContFallidos := Var_ContFallidos +1;
					
					UPDATE TC_FECHACARGAPROSA SET
						IntentosFallidos = Var_ContFallidos,
						Estatus = Par_Estatus,
						HoraEjecucion = Par_HoraEjecucion,
						
						EmpresaID = Aud_EmpresaID,
						Usuario = Aud_Usuario,
						FechaActual = Aud_FechaActual,
						DireccionIP = Aud_DireccionIP,
						ProgramaID = Aud_ProgramaID,
						Sucursal = Aud_Sucursal, 
						NumTransaccion = Aud_NumTransaccion
						WHERE FechaCargaProsaID = Var_FCargaProsaID;
				END IF;
				
				-- Actualiza el estatus
				IF(Par_Estatus = Estatus_Exito) THEN
					UPDATE TC_FECHACARGAPROSA
						SET Estatus = Par_Estatus,
							EmpresaID = Aud_EmpresaID,
							HoraEjecucion = Par_HoraEjecucion,
							
							Usuario = Aud_Usuario,
							FechaActual = Aud_FechaActual,
							DireccionIP = Aud_DireccionIP,
							ProgramaID = Aud_ProgramaID,
							Sucursal = Aud_Sucursal, 
							NumTransaccion = Aud_NumTransaccion
							WHERE FechaCargaProsaID = Var_FCargaProsaID;
				END IF;
		END IF;
		
		SET Par_NumErr:= 0;
		SET Par_ErrMen:= 'Fecha de busqueda de archivo agregada correctamente.';
	END IF;
		
	IF(Par_NumPro = Pro_Reseteo ) THEN
		-- Resetea valores a 0 con estatus F;
		UPDATE TC_FECHACARGAPROSA SET
				Estatus 			= Estatus_Fallido,
				IntentosFallidos 	= Entero_Cero,
				
				Usuario = Aud_Usuario,
				FechaActual = Aud_FechaActual,
				DireccionIP = Aud_DireccionIP,
				ProgramaID = Aud_ProgramaID,
				Sucursal = Aud_Sucursal, 
				NumTransaccion = Aud_NumTransaccion
			WHERE Fecha = Par_FechaEjec
			AND TipoArchivo = Par_TipoArchivo
			AND Estatus = Estatus_Fallido;
			
			SET Par_NumErr:= 0;
			SET Par_ErrMen:= 'Reinicio de conteo de intentos realizado correctamente.';
	END IF;
		
END ManejoErrores;

   IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$
