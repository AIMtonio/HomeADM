-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIATMENCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCIATMENCALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCIATMENCALT`(
		-- Encabezado de la carga de archivo de conciliacion ATM
		Par_Fecha			CHAR(6),			-- Fecha del Archivo S6
		Par_Codigo			VARCHAR(15),		-- Codigo del archivo STAT : STAT06

		Par_Salida          CHAR(1),			-- Indica el tipo de salida S.- SI N.- No
  INOUT Par_NumErr    		INT,				-- Numero de Error
  INOUT Par_ErrMen    		VARCHAR(400),		-- Mensaje de Error

		Aud_EmpresaID		INT(11),            -- Auditoria
		Aud_Usuario			INT(11),            -- Auditoria
		Aud_FechaActual		DATETIME,           -- Auditoria
		Aud_DireccionIP		VARCHAR(15),        -- Auditoria
		Aud_ProgramaID		VARCHAR(50),        -- Auditoria
		Aud_Sucursal		INT,                -- Auditoria
		Aud_NumTransaccion	BIGINT              -- Auditoria
	)
TerminaStore:BEGIN


-- Declaracion de Variables
DECLARE Var_ConciliaATMID	INT;                -- Id del archivo de conciliacion
DECLARE Var_Control			VARCHAR(15);        -- Campo de control
DECLARE Var_FechaArchivo 	DATE;               -- Fecha del archivo de conciliacion

-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);            -- cadena vacia
DECLARE Entero_Cero			INT;                -- Entero vacio
DECLARE Salida_SI			CHAR(1);            -- Salida del SP
DECLARE TipoRetiro			VARCHAR(15);        -- Tipo de movimiento "retiro"

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';		-- Cadena Vacia
SET Entero_Cero				:= 0;		-- Entero Cero
SET Salida_SI				:= 'S';		-- Salida SI
SET Var_FechaArchivo 		:= STR_TO_DATE(Par_Fecha,'%d%m%y');

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBCONCIATMENCALT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		IF (IFNULL(Par_Fecha, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'La Fecha esta Vacia';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_Codigo, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Codigo esta Vacio';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF EXISTS (SELECT Fecha FROM TARDEBCONCIATMENC WHERE Fecha = Var_FechaArchivo) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'Archivo Procesado Anteriormente';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        IF SUBSTR(TRIM(Par_Codigo),1,6) <> 'STAT06' THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'Formato de Archivo Incorrecto';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
        END IF;

		CALL FOLIOSAPLICAACT('TARDEBCONCIATMENC', Var_ConciliaATMID);

		INSERT INTO `TARDEBCONCIATMENC`(
			`ConciliaATMID`,	`Fecha`,	`Codigo`,	`EmpresaID`,	`Usuario`,
			`FechaActual`,		`DireccionIP`,	`ProgramaID`,	`Sucursal`,	`NumTransaccion`)
		VALUES(
			Var_ConciliaATMID, 	Var_FechaArchivo, 	Par_Codigo, 	Aud_EmpresaID, 	Aud_Usuario,
			Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID, Aud_Sucursal,	Aud_NumTransaccion );

		SET Par_NumErr	:= '000';
		SET Par_ErrMen	:= 'Registro Guardado Exitosamente.';
		SET Var_Control	:= '';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI)THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen	AS ErrMen,
			Var_Control AS control,
			Var_ConciliaATMID AS consecutivo;
	END IF;

END TerminaStore$$