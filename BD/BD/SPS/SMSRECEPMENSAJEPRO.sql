-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSRECEPMENSAJEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSRECEPMENSAJEPRO`;DELIMITER $$

CREATE PROCEDURE `SMSRECEPMENSAJEPRO`(
# =====================================================================================
#	STORE PARA FORMAR ACTUALIZAR LOS MENSAJES DE CAMPAÑAS ITERATIVAS
# =====================================================================================
	Par_NumCon				TINYINT UNSIGNED,
	Par_RecepMensajeID      INT(11),
	Par_Remitente        	VARCHAR(15),
	Par_Mensaje          	VARCHAR(400),
	Par_FechaRespuesta	   	DATE,

    Par_Salida				CHAR(1),
    INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID           INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

    -- Declaracion de Variables
	DECLARE	Var_Control		VARCHAR(100);
    DECLARE Var_Consecutivo	BIGINT(20);		-- Variable consecutivo
	DECLARE VarEnvioID      INT;
	DECLARE VarCampaniaID   INT;
	DECLARE VarCount        INT;

    -- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Con_Principal	INT;
    DECLARE	Var_Procesado	CHAR(1);		-- Estatus Procesado de Tabla SMSRECEPMENSAJE
    DECLARE	Salida_SI		CHAR(1);

	DECLARE  CursorMov  CURSOR FOR
		SELECT msg.EnvioID, cod.CampaniaID
			FROM SMSENVIOMENSAJE msg
			LEFT JOIN SMSCODIGOSRESP cod ON msg.CampaniaID	= cod.CampaniaID
			WHERE	cod.CodigoRespID	= Par_Mensaje
              AND	msg.Receptor		= Par_Remitente;

	SET VarCount        := 0;
	SET Con_Principal   := 1;
	SET Cadena_Vacia    := '';
	SET Fecha_Vacia     := '1900-01-01';
	SET Entero_Cero     := 0;
    SET	Var_Procesado	:= 'P';
    SET	Salida_SI		:= 'S';

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSRECEPMENSAJEPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF(Par_NumCon = Con_Principal)THEN

			 SELECT COUNT(msg.EnvioID) INTO VarCount
				FROM SMSENVIOMENSAJE msg
				LEFT JOIN SMSCODIGOSRESP cod ON msg.CampaniaID = cod.CampaniaID
				WHERE	cod.CodigoRespID	= Par_Mensaje
                  AND	msg.Receptor		= Par_Remitente;

			IF(VarCount != Entero_Cero) THEN
				Open  CursorMov;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLO:LOOP
						FETCH CursorMov  INTO
							VarEnvioID,	VarCampaniaID;

						IF(IFNULL(VarEnvioID, Cadena_Vacia) != Cadena_Vacia) THEN
							UPDATE SMSENVIOMENSAJE SET
								CodigoRespuesta	= Par_Mensaje,
								FechaRespuesta	= Par_FechaRespuesta
							WHERE	EnvioID		= VarEnvioID;

							UPDATE SMSRECEPMENSAJE SET
								CampaniaID 	= VarCampaniaID,
								Estatus		= 'P'
							WHERE	RecepMensajeID	= Par_RecepMensajeID
                              AND	Remitente		= Par_Remitente;

							SET Par_NumErr	:= 000;
							SET Par_ErrMen	:= CONCAT('Mensaje de: ',Par_Remitente, ' Respondio a la Campaña ', VarCampaniaID );
							SET Var_Control	:= 'cuentaAhoID';
							SET	Var_Consecutivo	:= Par_RecepMensajeID;

						END IF;
					END LOOP CICLO;
				END;
				Close CursorMov;
			ELSE
				SET Par_NumErr		:= 001;
				SET Par_ErrMen		:= CONCAT('Mensaje de: ',Par_Remitente, ' No Corresponde a ninguna campaña');
				SET Var_Control		:= 'RecepMensajeID';
                SET	Var_Consecutivo	:= Par_RecepMensajeID;
				LEAVE ManejoErrores;
			END IF;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$