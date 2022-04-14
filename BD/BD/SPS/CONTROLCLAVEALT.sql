-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTROLCLAVEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTROLCLAVEALT`;DELIMITER $$

CREATE PROCEDURE `CONTROLCLAVEALT`(
/* Registra las claves mensuales de SAFI */
	Par_ClienteID			VARCHAR(50),	-- Nombre corto del cliente
	Par_Anio				CHAR(4), 		-- Año de la licencia
	Par_Mes					CHAR(2), 		-- Mes de la licencia
	Par_ClaveKey			VARCHAR(100), 	-- Serial de la licencia

	Par_Salida          	CHAR(1), 		-- Salida
	INOUT Par_NumErr		INT, 			-- Salida
	INOUT Par_ErrMen		VARCHAR(400),	-- Salida

	Aud_EmpresaID			INT,			-- Auditoria
	Aud_Usuario				INT,			-- Auditoria
	Aud_FechaActual			DATETIME,		-- Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Auditoria
	Aud_ProgramaID			VARCHAR(100),	-- Auditoria
	Aud_Sucursal			INT,			-- Auditoria
	Aud_NumTransaccion		BIGINT			-- Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Control		VARCHAR(100);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE SalidaSI        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia    := ''; 			-- Cadena vacia
SET Entero_Cero     := 0;			-- Entero en cero
SET SalidaSI        := 'S';         -- El Store SI genera una Salida
SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CONTROLCLAVEALT');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

	IF(IFNULL(Par_ClienteID,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'El Nombre del Cliente Esta Vacio';
        SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Anio,Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'Especifique el Año';
        SET Var_Control := 'anio';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Mes, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 003;
        SET Par_ErrMen  := 'El Mes esta Vacio';
        SET Var_Control := 'telContactoRH';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ClaveKey, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 004;
        SET Par_ErrMen  := 'La Clave Esta Vacia';
        SET Var_Control := 'claveKey';
		LEAVE ManejoErrores;
	END IF;

	-- Inserta los datos en la tabla CONTROLCLAVE
	INSERT INTO `CONTROLCLAVE`(
		`ClienteID`,	`Anio`,			`Mes`,			`ClaveKey`,		`EmpresaID`,
		`Usuario`,		`FechaActual`,	`DireccionIP`,	`ProgramaID`,	`Sucursal`,
		`NumTransaccion`)
	VALUES(
		Par_ClienteID,	Par_Anio,			Par_Mes,		Par_ClaveKey,	Aud_EmpresaID,
		Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := "Clave Agregada Exitosamente";
	SET Var_Control := 'clienteID';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$