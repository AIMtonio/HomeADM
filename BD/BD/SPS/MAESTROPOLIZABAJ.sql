-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAESTROPOLIZABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `MAESTROPOLIZABAJ`;DELIMITER $$

CREATE PROCEDURE `MAESTROPOLIZABAJ`(
	-- STORE PARA REALIZAR LA BAJA DEL MAESTRO DE POLIZAS
	Par_Poliza			BIGINT(20),			-- Numero de Poliza
	Par_Transaccion		BIGINT(20),			-- Numero de Transaccion
	Par_Tipo			TINYINT UNSIGNED,	-- Tipo de Baja
	Par_NumErrPol		INT(11),			-- Numero de Error que genero la cancelacion de la poliza
	Par_ErrMenPol		VARCHAR(400),		-- Mensaje de error del proceso que cancelo la poliza

	Par_DescProceso		VARCHAR(400),		-- Descripcion del proceso que realizo la poliza
	Par_Salida			CHAR(1), 			-- Especifica si Hay Salida o No
	INOUT	Par_NumErr	INT(11),			-- Control de Errores: Numero de Error
	INOUT	Par_ErrMen	VARCHAR(400),		-- Control de Errores: Descripcion del Error
	Aud_EmpresaID		INT(11),			-- Parametro de Auditoria

	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria

	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control	    	VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);     -- Variable consecutivo

	-- Declaracion de Constante
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE Var_TipoPoliza		TINYINT UNSIGNED;
	DECLARE	Var_TipoTransaccion	TINYINT UNSIGNED;

	SET	Entero_Cero				:= 0;			-- Entero en Cero
	SET	Salida_NO       		:= 'N';			-- Salida en pantalla NO
	SET Salida_SI       		:= 'S';         -- Salida si
	SET Var_TipoPoliza			:= 1;			-- Tipo de Borrado por medio de Numero de Poliza
	SET	Var_TipoTransaccion		:= 2;			-- Tipo de Borrado por medio del Numero de Transaccion


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-MAESTROPOLIZABAJ');
			SET Var_Control := 'sqlException' ;
		END;

		IF NOT((IFNULL(Par_Tipo,Entero_Cero) = Var_TipoPoliza)
			OR (IFNULL(Par_Tipo,Entero_Cero) =  Var_TipoTransaccion) ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= CONCAT('Tipo de Baja de Poliza no Valida,  Tipo: ', CAST(Par_Tipo AS CHAR));
			SET Var_Control	:= 'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Tipo = Var_TipoPoliza)THEN

			IF IFNULL(Par_Poliza,Entero_Cero) = Entero_Cero THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('Poliza Vacia,  Poliza: ', CAST(Par_Poliza AS CHAR));
				SET Var_Control	:= 'polizaID' ;
				LEAVE ManejoErrores;

			END IF;

			IF NOT EXISTS ( SELECT PolizaID FROM POLIZACONTABLE
							WHERE PolizaID	= Par_Poliza) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('La Poliza No Existe,  Poliza: ', CAST(Par_Poliza AS CHAR));
				SET Var_Control	:= 'polizaID' ;
				LEAVE ManejoErrores;

			END IF;

			IF EXISTS ( SELECT PolizaID FROM DETALLEPOLIZA
							WHERE PolizaID	= Par_Poliza) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= CONCAT('Tiene Registros en Detalle de Poliza, No se Puede Dar de Baja, Poliza: ', CAST(Par_Poliza AS CHAR));
				SET Var_Control	:= 'polizaID' ;
				LEAVE ManejoErrores;
			END IF;

			/*Realiza Respaldo de la poliza contable
			Esta parte es importante ya que para auditorias las polizas deben mantenerse consecutivas
			*/
			CALL POLIZASCANCELADASALT(
				Par_Poliza,			Par_Transaccion,	Par_DescProceso,	Par_NumErrPol,			Par_ErrMenPol,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
			);

			IF(Par_NumErr>Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			/*Fin de respaldo*/

			DELETE FROM POLIZACONTABLE
				  WHERE	PolizaID	= Par_Poliza;
		END IF;

		/*NOTA IMPORTANTE: No utilizar por transaccion para procesos de cierres ya que las polizas automáticas
		comparten el mismo número de transacción este proceso es de CAME los demás ambientes no lo utilizan*/
		IF (Par_Tipo = Var_TipoTransaccion)THEN

			IF IFNULL(Par_Transaccion, Entero_Cero) = Entero_Cero THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('Numero de Transaccion Vacio,  Transaccion: ', CAST(Par_Transaccion AS CHAR));
				SET Var_Control	:= 'polizaID' ;
				LEAVE ManejoErrores;

			END IF;

			IF NOT EXISTS ( SELECT PolizaID FROM POLIZACONTABLE
							WHERE NumTransaccion	= Par_Transaccion) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('La Transaccion No Existe en Poliza Contable,  Transaccion: ', CAST(Par_Transaccion AS CHAR));
				SET Var_Control	:= 'polizaID' ;
				LEAVE ManejoErrores;

			END IF;

			IF EXISTS ( SELECT PolizaID FROM DETALLEPOLIZA
							WHERE NumTransaccion	= Par_Transaccion) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('Tiene Registros en Detalle de Poliza, No se Puede Dar de Baja, Transaccion: ', CAST(Par_Transaccion AS CHAR));
				SET Var_Control	:= 'polizaID' ;
				LEAVE ManejoErrores;
			END IF;

			/*Realiza Respaldo de la poliza contable
			Esta parte es importante ya que para auditorias las polizas deben mantenerse consecutivas
			*/
			CALL POLIZASCANCELADASALT(
				Par_Poliza,			Par_Transaccion,	Par_DescProceso,	Par_NumErrPol,			Par_ErrMenPol,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
			);

			IF(Par_NumErr>Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			/*Fin de respaldo*/

			DELETE FROM POLIZACONTABLE
				  WHERE	NumTransaccion	= Par_Transaccion;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Poliza Borrada Exitosamente: ', CAST(Par_Poliza AS CHAR));
		SET Var_Control	:= 'polizaID' ;
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					Var_Control 	AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$