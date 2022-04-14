-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROFALTANTESOBRANTEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROFALTANTESOBRANTEACT`;
DELIMITER $$


CREATE PROCEDURE `REGISTROFALTANTESOBRANTEACT`(
	-- Store para actualiar solicitud de ajuste de faltante y sobrante de caja
	Par_SoliciAjuID			INT(11),			-- id de la solicitud de ajuste de caja
	Par_NumAct				INT(1),				-- Numero de actualizacion
	Par_Salida          	CHAR(1),			-- Especifica si se necesita una salida o no

    INOUT Par_NumErr    	INT(11),			-- Parametro de salida con numero de error
    INOUT Par_ErrMen    	VARCHAR(400),		-- Parametro de salida con mensaje de error
    Aud_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria

	Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control     		VARCHAR(50);	-- Devuelve al  usuario al usuario un campo de control

    -- Declaracion de constantes
    DECLARE Cadena_Vacia    		CHAR(1);		-- Cadena vacia
    DECLARE Fecha_Vacia     		VARCHAR(15);	-- Fecha vacia
	DECLARE Entero_Cero     		INT; 			-- Entero cero
	DECLARE SalidaSI        		CHAR(1);		-- Salida SI
	DECLARE Act_Principal			INT(1);			-- Actualiza el estatus de la solicitud
	DECLARE Est_Autorizado			CHAR(1);		-- Estatus autorizado
	

	-- Asignacion  de constantes
	SET Cadena_Vacia    			:='' ;              -- Cadena o string vacio
	SET Entero_Cero     			:= 0 ;              -- Entero en cero
    SET Fecha_Vacia					:='1900-01-01';		-- Fecha vacia
	SET SalidaSI        			:='S';				-- El Store SI genera una Salida
	SET Act_Principal				:= 1;				-- Actualizacion de estatus
	SET Est_Autorizado				:= 'A';				-- Estatus Autorizado
	
	SET Aud_FechaActual 		    := NOW() ;

	ManejoErrores: BEGIN
       DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-REGISTROFALTANTESOBRANTEACT');
				SET Var_Control = 'SQLEXCEPTION';
			END;
	 -- 1. actualiza el estatus del ajuste a autorizado
	IF(Par_NumAct = Act_Principal) THEN
		
		IF(IFNULL(Par_SoliciAjuID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen		:= 'El id de la solicitud se encuentra vacia';
			SET Var_Control 	:= 'regFaltanteSobranteID';
			LEAVE ManejoErrores;
		END IF;
		
		UPDATE REGISTROFALTANTESOBRANTE SET
		Estatus = Est_Autorizado
		WHERE RegFaltanteSobranteID = Par_SoliciAjuID;
		
		SET Par_NumErr 		:= 000;
		SET Par_ErrMen		:= 'Solicitud de ajuste autorizado correctamente.';
		SET Var_Control 	:= 'regFaltanteSobranteID';
		LEAVE ManejoErrores;
		
	END IF;
	
	
	END ManejoErrores;  -- END del Handler de Errores
	
	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Aud_NumTransaccion  AS consecutivo;
	END IF;


END TerminaStore$$
