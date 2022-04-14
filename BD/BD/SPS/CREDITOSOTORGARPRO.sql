-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSOTORGARPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSOTORGARPRO`;DELIMITER $$

CREATE PROCEDURE `CREDITOSOTORGARPRO`(
	Par_CreditoID		BIGINT,
    Par_Estatus			CHAR(1),
    Par_Salida        	CHAR(1),
	INOUT Par_NumErr    INT,
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


DECLARE MontoTotal			DECIMAL(14,2);
DECLARE Var_Nomina			CHAR(1);
DECLARE varControl          CHAR(15);


DECLARE Entero_Cero			INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Con_Principal   	INT(11);
DECLARE Est_Proceso			CHAR(1);
DECLARE Var_Si				CHAR(1);
DECLARE Var_No				CHAR(1);



SET Entero_Cero			:= 0;
SET Cadena_Vacia 		:= '';
SET Con_Principal       := 1;
SET Est_Proceso 		:= 'M';
SET Var_Si				:= 'S';
SET Par_NumErr    := 0;
SET Par_ErrMen    := '';


ManejoErrores: BEGIN
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			         'esto le ocasiona. Ref: SP-CREDITOSOTORGARPRO');
			END;

            IF(Par_Estatus = Var_Si) THEN
				UPDATE CREDITOS
				SET Estatus = Est_Proceso
				WHERE CreditoID =Par_CreditoID;
			END IF;

			SET 	Par_NumErr := 0;
			SET 	Par_ErrMen := CONCAT('Operacion Realizada Correctamente: ');
			SET		varControl := 'CREDITOS';

END ManejoErrores;

	IF(Par_Salida =Var_Si) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen  AS ErrMen,
		Cadena_Vacia AS control,
		Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$