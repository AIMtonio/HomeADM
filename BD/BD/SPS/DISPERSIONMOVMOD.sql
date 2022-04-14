-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVMOD`;DELIMITER $$

CREATE PROCEDURE `DISPERSIONMOVMOD`(
# =========================================================================
# ----------SP PARA MODIFICAR LOS DETALLES DE LAS DISPERSIONES-----------
# =========================================================================
	Par_ClaveDispMov    INT(11),
	Par_DispersionID    INT(11),
	Par_CuentaCargo     BIGINT(12),
	Par_Descripcion     VARCHAR(50),
	Par_Referencia      VARCHAR(50),
	Par_TipoMovDIspID   INT(11),
	Par_FormaPago	    INT(11),
	Par_Monto           DECIMAL(12,2),
	Par_CuentaDestino   VARCHAR(25),
	Par_Identificacion  VARCHAR(16),
	Par_Estatus         VARCHAR(2),
	Par_NombreBenefi    VARCHAR(70),
	Par_FechaEnvio      DATETIME,
    Par_TipoChequera	CHAR(2),

	Par_Salida          CHAR(1),
	OUT Par_NumErr      INT(11),
	OUT Par_ErrMen      VARCHAR(400),

    Aud_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Cad_vacia 		VARCHAR(1);
	DECLARE Entero_Cero		INT(11);
	DECLARE Flotante_Cero  	DECIMAL(12,2);
	DECLARE TipoMov_Spei 	INT(11);
	DECLARE TipoMov_Orden 	INT(11);
	DECLARE Fecha_Vacia 	DATETIME;

    -- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(100);
	DECLARE Var_Consec		BIGINT(12);

	-- Asigancion de constantes
	SET Cad_vacia     		:= '';
	SET Entero_Cero   		:= 0;
	SET Flotante_Cero 		:= 0.00;
	SET TipoMov_Spei  		:= 1;
	SET TipoMov_Orden 		:= 2;
	SET	Fecha_Vacia   		:= '1900-01-01 00:00:00';

    ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPERSIONMOVMOD');
			END;


		IF(IFNULL(Par_ClaveDispMov, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La cuenta clave de dispersion vacia.';
			SET Var_Control:= 'claveDispMov';
			SET Var_Consec:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DispersionID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'No se encuentra el folio de operacion.';
			SET Var_Control:= 'dispersionID';
			SET Var_Consec:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaCargo, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'La cuenta de ahorro esta vacia.';
			SET Var_Control:= 'cuentaCargo';
			SET Var_Consec:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoMovDIspID = TipoMov_Spei)THEN
			 IF(Par_FechaEnvio = '')THEN
				SET Par_NumErr 	:= 5;
				SET Par_ErrMen 	:= 'La fecha de envio esta vacia.';
				SET Var_Control	:= 'fechaEnvio';
				SET Var_Consec	:= Entero_Cero;
				LEAVE ManejoErrores;
			 END IF;

			IF(IFNULL(Par_NombreBenefi, Cad_vacia) = Cad_vacia)THEN
				SET Par_NumErr 	:= 4;
				SET Par_ErrMen 	:= 'El nombre del beneficiario esta vacio.';
				SET Var_Control	:= 'NombreBenefi';
				SET Var_Consec	:= Entero_Cero;
				LEAVE ManejoErrores;
			 END IF;
		END IF;

		IF(Par_TipoMovDIspID = TipoMov_Orden)THEN
			IF(IFNULL(Par_FechaEnvio, Fecha_Vacia)=Fecha_Vacia)THEN
				SET Par_FechaEnvio := Fecha_Vacia;
			 END IF;

			IF(IFNULL(Par_NombreBenefi, Cad_vacia)=Cad_vacia)THEN
				SET Par_NombreBenefi := Cad_vacia;
			END IF;
		END IF;

		IF(IFNULL(Par_Monto, Flotante_Cero) = Flotante_Cero) THEN
			SET Par_NumErr 	:= 6;
			SET Par_ErrMen 	:= 'El monto esta vacio.';
			SET Var_Control	:= 'monto';
			SET Var_Consec	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaDestino, Cad_vacia)= Cad_vacia) THEN
			SET Par_NumErr 	:= 7;
			SET Par_ErrMen 	:= 'La Cuenta Clabe esta vacia.';
			SET Var_Control	:= 'CuentaDestino';
			SET Var_Consec	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Identificacion, Cad_vacia) = Cad_vacia)THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'La Cuenta Clabe esta vacia.';
			SET Var_Control:= 'identificacion';
			SET Var_Consec:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		UPDATE  DISPERSIONMOV  SET
			  CuentaCargo    	= Par_CuentaCargo,
			  Descripcion    	= Par_Descripcion,
			  Referencia     	= Par_Referencia,
			  TipoMovDIspID  	= Par_TipoMovDIspID,
			  FormaPago		 	= Par_FormaPago,
			  Monto         	= Par_Monto,
			  CuentaDestino 	= Par_CuentaDestino,
			  Identificacion	= Par_Identificacion,
			  Estatus       	= Par_Estatus ,
			  NombreBenefi  	= Par_NombreBenefi,
			  FechaEnvio     	= Par_FechaEnvio,
			  TipoChequera		= Par_TipoChequera,

			  EmpresaID      	= Aud_EmpresaID ,
			  Usuario        	= Aud_Usuario,
			  FechaActual    	= Aud_FechaActual,
			  DireccionIP    	= Aud_DireccionIP,
			  ProgramaID     	= Aud_ProgramaID ,
			  Sucursal       	= Aud_Sucursal,
			  NumTransaccion 	= Aud_NumTransaccion

		WHERE	ClaveDispMov	= Par_ClaveDispMov
        AND 	DispersionID	= Par_DispersionID;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen 	:= CONCAT("Las Dispersiones del Folio:",CONVERT(Par_DispersionID, CHAR),"  han sido Modificadas Exitosamente.");
        SET Var_Control	:= 'CuentaAhoID';
		SET Var_Consec 	:= Par_ClaveDispMov;

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
			   		Par_ErrMen AS ErrMen,
			   		Var_Control AS control,
			   		consecutivo AS consecutivo;
		END IF;

END TerminaStore$$