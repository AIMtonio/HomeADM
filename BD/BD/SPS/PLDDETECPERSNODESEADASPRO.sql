-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECPERSNODESEADASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECPERSNODESEADASPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDDETECPERSNODESEADASPRO`(
	/* SP DE PROCESO QUE DETECTA A UNA PERSONA EN LISTAS DE PERS. NO DESEADAS. EN EL ALTA O EN LA MODIFICACION */
	Par_ClavePersonaInv		INT(11),	    	-- Numero de Cliente o Usuario de Servicios Modificado, cero si es en el alta
	Par_RFC					CHAR(13),		-- RFC de la persona (fisica o moral)
	Par_TipoPersona			CHAR(1),		-- F. Fisica A. Fisica con Act Empresarial M. Moral
	Par_Salida				CHAR(1),		-- Tipo de Salida S. Si N. No

	INOUT	Par_NumErr 		INT(11),		-- Numero de Error
	INOUT	Par_ErrMen  	VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,

	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_PersNoDeseadaID	BIGINT(12);
	DECLARE Var_TipoPersona		CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE DescripOPMod		VARCHAR(52);
	DECLARE Entero_Cero			INT;
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE PersActEmp			CHAR(1);
	DECLARE PersFisica			CHAR(1);
	DECLARE PersMoral 			CHAR(1);
	DECLARE Str_No				CHAR(1);
	DECLARE Str_Si				CHAR(1);

    -- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Decimal_Cero			:= 0.0;				-- DECIMAL Cero
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Estatus_Activo			:= 'A';				-- Estatus Activo
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET PersActEmp				:= 'A';				-- Tipo de persona fisica con actividad empresarial
	SET PersFisica				:= 'F';				-- Tipo de persona fisica
	SET PersMoral				:= 'M';				-- Tipo de persona moral
	SET Str_No					:= 'N';				-- Constante no
	SET Str_Si					:= 'S';				-- Constante si

    -- Asignacion de Variable
	SET Par_RFC 				:=TRIM(IFNULL(Par_RFC, Cadena_Vacia));

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDDETECPERSNODESEADASPRO');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;


		SELECT
			PersNoDeseadaID
			INTO
			Var_PersNoDeseadaID
			FROM PLDLISTAPERSNODESEADAS
			WHERE RFC = Par_RFC /*RFC*/
				AND Estatus = Estatus_Activo
				LIMIT 1;

		SET Var_PersNoDeseadaID	:= IFNULL(Var_PersNoDeseadaID,Entero_Cero);

		IF(Var_PersNoDeseadaID != Entero_Cero) THEN
			SET Par_NumErr := 50;
			SET Par_ErrMen	:=CONCAT('Cliente no cumple la politica interna de Riesgos.');
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 00;
		SET Par_ErrMen	:='No hay coincidencias.';
	END ManejoErrores;

	IF(Par_Salida=Str_Si)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_PersNoDeseadaID AS Consecutivo,
				'persNoDeseadaID' AS Control;
	END IF;
END TerminaStore$$