-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIATMENCACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCIATMENCACT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCIATMENCACT`(
		-- Actualiza el total de registros procesados del archivo ATM
		Par_ConciliaATMID	INT(11),		-- Identificador del encabezado del archivo
		Par_Fecha			CHAR(6),		-- Fecha de operaciones
		Par_Codigo			VARCHAR(15),	-- Codigo del Archivo STAT
		Par_TotalTransac	INT(11),		-- Total de Transacciones en el archivo CSV
		Par_Salida          CHAR(1),		-- Indica el tipo de salida S.- SI N.- No
  INOUT Par_NumErr    		INT,			-- Numero de Error
  INOUT Par_ErrMen    		VARCHAR(400),	-- Mensaje de Error

		Aud_EmpresaID		INT(11),        -- Auditoria
		Aud_Usuario			INT(11),        -- Auditoria
		Aud_FechaActual		DATETIME,       -- Auditoria
		Aud_DireccionIP		VARCHAR(15),    -- Auditoria
		Aud_ProgramaID		VARCHAR(50),    -- Auditoria
		Aud_Sucursal		INT,            -- Auditoria
		Aud_NumTransaccion	BIGINT          -- Auditoria
	)
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_ConciliaATMID	INT;            -- Clave del archivo de conciliacion
DECLARE Var_Control			VARCHAR(15);    -- Campo de Control

-- Declaracion de Constantes
DECLARE Cadena_Vacia	CHAR(1);    -- Cadena vacia
DECLARE Entero_Cero		INT;        -- Entero Cero
DECLARE Salida_SI		CHAR(1);    -- Salida del SP
DECLARE Var_FechaArchivo DATE;      -- Fecha del Archivo de conciliacion


SET Var_FechaArchivo := STR_TO_DATE(Par_Fecha,'%d%m%y');


-- Asignacion de Constantes
SET Cadena_Vacia	:= '';		-- Cadena Vacia
SET Entero_Cero		:= 0;		-- Entero Cero
SET Salida_SI		:= 'S';		-- Salida SI

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBCONCIATMENCACT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;


		IF (IFNULL(Par_ConciliaATMID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Conciliacion Esta Vacio';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_Fecha, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'La Fecha esta Vacia';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_Codigo, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Codigo esta Vacio';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        SELECT COUNT(DetalleATMID) AS TotalOperaciones INTO Par_TotalTransac FROM
				TARDEBCONCIATMDET WHERE ConciliaATMID = Par_ConciliaATMID;

		UPDATE `TARDEBCONCIATMENC`	SET
			`TotalTransac`      = Par_TotalTransac,
			`EmpresaID`         = Aud_EmpresaID,
			`Usuario`           = Aud_Usuario,
			`FechaActual`       = Aud_FechaActual,
			`DireccionIP`       = Aud_DireccionIP,
			`ProgramaID`        = Aud_ProgramaID,
			`Sucursal`          = Aud_Sucursal,
			`NumTransaccion`    = Aud_NumTransaccion
		WHERE ConciliaATMID = Par_ConciliaATMID
			AND `Fecha` = Var_FechaArchivo;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Registro Actualizado Exitosamente.';
		SET Var_Control	:= '';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI)THEN
		SELECT
			Par_NumErr    AS NumErr,
			Par_ErrMen	  AS ErrMen,
			Var_Control   AS control,
			Cadena_Vacia  AS consecutivo;
	END IF;

END TerminaStore$$