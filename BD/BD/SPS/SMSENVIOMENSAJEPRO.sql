-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSENVIOMENSAJEPRO`;DELIMITER $$

CREATE PROCEDURE `SMSENVIOMENSAJEPRO`(
# ===================================================================
# ------------- SP PARA ALTA DE ENVIO DE MENSAJES MASIVO-------------
# ===================================================================
	Par_TipoEnvio		CHAR(1),
	Par_NumVeces 		INT(11),
	Par_Distancia 		TIME,
    Par_Remitente		VARCHAR(45),
	Par_Receptor		VARCHAR(45),

	Par_FechaRealEnvio  DATETIME,
	Par_Mensaje 		VARCHAR(400),
	Par_FechaProgEnvio	DATETIME,
    Par_CampaniaID		INT(11),
	Par_FechaResp		DATETIME,

	Par_CtaAsoc     	VARCHAR(45),
	Par_NumCliente  	VARCHAR(45),
	Par_DatosCliente	VARCHAR(150),
	Par_SistemaID		VARCHAR(50),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

    -- Declaracion de variables
    DECLARE Var_Control		VARCHAR(100);
    DECLARE Consecutivo		VARCHAR(100);
    DECLARE Var_FechaProgEn	DATETIME;
    DECLARE Var_MinDis		TIME;
    DECLARE Var_FechaAum	DATETIME;
    DECLARE Var_FechaPan	DATETIME;
    DECLARE Var_FechaCon	DATETIME;
    DECLARE Var_EnvioID		INT(11);
    DECLARE Contador		INT(11);

	-- Declaracion de constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);
    DECLARE OpcAhora		INT(11);
    DECLARE OpcHorario		INT(11);
    DECLARE TipoEnvRep		CHAR(1);


	-- Asignacion de constantes
	SET	Entero_Cero			:= 0;		-- Entero Cero
	SET SalidaSI			:='S';		-- Salida Si
	SET SalidaNO			:='N';		-- Salida No
	SET	Cadena_Vacia		:= '';		-- String Vacio
    SET OpcAhora 			:= 1;		-- Opcion de envio ahora
    SET OpcHorario			:= 2;		-- OPcion de envio por horario
	SET TipoEnvRep			:= 'R';		-- Tipo de envio repetido
    SET Contador			:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSENVIOMENSAJEPRO');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SET Par_FechaProgEnvio 	:= IFNULL(Par_FechaProgEnvio, Aud_FechaActual );

        IF(Par_TipoEnvio = TipoEnvRep)THEN

			WHILE (Contador <= Par_NumVeces ) DO

                IF(Contador = 1)THEN
					 SET Var_FechaAum := (SELECT ADDTIME(Par_FechaProgEnvio,Par_Distancia));
				ELSE

                    SET Var_FechaAum := (SELECT ADDTIME(Var_FechaAum,Par_Distancia));

                END IF;

				CALL SMSENVIOMENSAJEALT(
					Par_Remitente,	Par_Receptor,	Par_FechaRealEnvio,	Par_Mensaje,	Var_FechaAum,
					Par_CampaniaID,	Par_FechaResp,	Par_CtaAsoc,		Par_NumCliente,	Par_DatosCliente,
					Par_SistemaID,	SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET	Contador := Contador + 1;
			END WHILE;


        ELSE

			CALL SMSENVIOMENSAJEALT(
				Par_Remitente,	Par_Receptor,	Par_FechaRealEnvio,	Par_Mensaje,	Par_FechaProgEnvio,
				Par_CampaniaID,	Par_FechaResp,	Par_CtaAsoc,		Par_NumCliente,	Par_DatosCliente,
				Par_SistemaID,	SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;

		SET Par_NumErr 	:= 000;
        SET Par_ErrMen 	:= 'Mensaje Registrado';
        SET Var_Control	:= 'campaniaID';
		SET Consecutivo := Par_CampaniaID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$