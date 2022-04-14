-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSACT`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSACT`(
	Par_InstitNominaID		INT(11),			-- INSTITUCION DE NOMINA
	Par_ClienteID			INT(11),			-- CLIENTE ID
	Par_ProspectoID			BIGINT(20),			-- PROSPECTO ID
	Par_Estatus				CHAR(1),			-- ESTATUS
    Par_ConvenioNominaID	BIGINT UNSIGNED,	-- Identificador del convenio
	Par_TipoAct       		INT(11),			-- TIPO DE ACTUALIZACION

	Par_Salida				CHAR(1),			-- SALIDA
	INOUT Par_NumErr		INT(11),			-- NUMERO DE ERROR
	INOUT Par_ErrMen  		VARCHAR(400),		-- MENSAJE DE ERROR
	-- PARAMETROS DE AUDITORIA
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal       		INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN


DECLARE Var_Control     	VARCHAR(100);
DECLARE Var_Estatus     	VARCHAR(1);



DECLARE	EstatusBaja			CHAR(1);
DECLARE	EstatusAlta			CHAR(1);
DECLARE	EstatusInca			CHAR(1);
DECLARE	SalidaSI		    CHAR(1);
DECLARE	Act_EstBaja			INT(11);
DECLARE	Act_EstAlta			INT(11);
DECLARE	Act_EstInca			INT(11);
DECLARE	Entero_Cero			INT(11);
DECLARE  Act_InstitNom  	INT(11);


SET   Act_InstitNom      	:= 4;


SET	EstatusBaja				:='B';
SET	EstatusAlta				:='A';
SET	EstatusInca				:='I';
SET	Act_EstBaja				:=  2;
SET	Act_EstAlta				:=  1;
SET	Act_EstInca				:=  3;
SET	SalidaSI			    :='S';
SET Entero_Cero			    :=  0;

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-NOMINAEMPLEADOSACT');
				SET Var_Control = 'sqlException' ;
			END;



IF(NOT EXISTS(SELECT InstitNominaID
			FROM INSTITNOMINA
			WHERE InstitNominaID = Par_InstitNominaID)) THEN
		SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'La institucion no existe';
        SET Var_Control := 'institNominaID';
        LEAVE ManejoErrores;
END IF;
SET Par_ClienteID   := IFNULL(Par_ClienteID, Entero_Cero);
IF(Par_ClienteID != Entero_Cero) then
	IF(NOT EXISTS(SELECT ClienteID
                    FROM CLIENTES
                        WHERE ClienteID = Par_ClienteID)) THEN
        SET Par_NumErr 		:= 002;
        SET Par_ErrMen  	:= 'El cliente especificado no existe';
        SET Var_Control 	:= 'clienteID';
		LEAVE ManejoErrores;
	END IF;

END IF;

SET Par_ProspectoID  := IFNULL(Par_ProspectoID, Entero_Cero);

IF(Par_ProspectoID != Entero_Cero) THEN
 IF(NOT EXISTS(SELECT ProspectoID
                    FROM PROSPECTOS
                        WHERE ProspectoID = Par_ProspectoID)) THEN
        SET Par_NumErr 		:= 003;
        SET Par_ErrMen  	:= 'El prospecto especificado no existe';
        SET Var_Control 	:= 'prospectoID';
		LEAVE ManejoErrores;
	END IF;
END IF;

IF(Par_ClienteID = Entero_Cero) THEN
	IF(Par_ProspectoID = Entero_Cero) THEN
		SET Par_NumErr 		:= 004;
        SET Par_ErrMen  	:= 'Se Requiere un Cliente o un Prospecto';
        SET Var_Control 	:= 'clienteID';
		LEAVE ManejoErrores;
	END IF;
END IF;

IF(Par_TipoAct = Act_InstitNom ) THEN
    IF(ifnull(Par_ProspectoID, Entero_Cero))= Entero_Cero THEN
        UPDATE	NOMINAEMPLEADOS	SET
				InstitNominaID = Par_InstitNominaID,

				EmpresaID           	= Par_EmpresaID,
				Usuario             	= Aud_Usuario,
				FechaActual         	= Aud_FechaActual,
				DireccionIP         	= Aud_DireccionIP,
				ProgramaID          	= Aud_ProgramaID,
			   NumTransaccion      		= Aud_NumTransaccion
        WHERE ClienteID = Par_ClienteID
        AND IFNULL(ConvenioNominaID, 0)=Par_ConvenioNominaID;

    END IF;
    IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
       UPDATE	NOMINAEMPLEADOS	SET
			InstitNominaID = Par_InstitNominaID,

			EmpresaID           	= Par_EmpresaID,
			Usuario             	= Aud_Usuario,
			FechaActual         	= Aud_FechaActual,
			DireccionIP         	= Aud_DireccionIP,
			ProgramaID          	= Aud_ProgramaID,
			NumTransaccion      	= Aud_NumTransaccion
        WHERE ProspectoID = Par_ProspectoID
        AND IFNULL(ConvenioNominaID, 0)=Par_ConvenioNominaID;

	END IF;

	SET Par_NumErr 		:= 000;
	SET Par_ErrMen  	:= 'Modificado Exitosamente';
	SET Var_Control 	:= 'institNominaID';
	LEAVE ManejoErrores;
END IF;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control;

END IF;

END TerminaStore$$