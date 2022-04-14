-- PAGINACIONHUELLAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGINACIONHUELLAPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGINACIONHUELLAPRO`(
    -- SP para devolver el numero de huellas existentes, el numero de registros por pagina y el numero de paginas.

    INOUT Par_NumHuellas        INT(11),            -- Parametro INOUT numero de huellas existentes
    INOUT Par_RegPorPagina      INT(11),            -- Parametro INOUT numero de registros por pagina
    INOUT Par_NumPaginas        INT(11),            -- Parametro INOUT numero de paginas

    Par_Salida                  CHAR(1),            -- Parametro de salida
    INOUT Par_NumErr			INT(11),            -- Parametro INOUT numero de error
	INOUT Par_ErrMen			VARCHAR(400),       -- parametro INOUT mensaje de error

    -- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore : BEGIN

    -- DECLARACION DE VARIABLES
    DECLARE Var_Control         VARCHAR(20);        -- Variable de control

    -- DECLARACION DE CONSTANTES
    DECLARE	Entero_Cero         INT(11);            -- Constante numero cero (0)
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante cadena vacia ''
    DECLARE Salida_SI           CHAR(1);            -- Constante de salida SI

    -- ASIGNACION DE CONSTANTES
    SET Entero_Cero         := 0;
    SET Cadena_Vacia        := '';
    SET Salida_SI           := 'S';

    ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  			'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGINACIONHUELLAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Par_NumHuellas := (SELECT COUNT(AutHuellaDigitalID) FROM HUELLADIGITAL);
        SET Par_NumHuellas := IFNULL(Par_NumHuellas, Entero_Cero);

        IF (Par_NumHuellas = Entero_Cero) THEN
            SET Par_NumErr	:= '001';
			SET Par_ErrMen	:= 'No hay huellas registradas para comparar.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
        END IF;

        SET Par_RegPorPagina := (SELECT RegistrosPagina FROM HUELLADIGITALPARAM LIMIT 1);
        SET Par_RegPorPagina := IFNULL(Par_RegPorPagina, Entero_Cero);

        IF (Par_RegPorPagina = Entero_Cero) THEN
            SET Par_NumErr	:= '002';
			SET Par_ErrMen	:= 'El numero de registros por pagina no esta configurado.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
        END IF;

        SET Par_NumPaginas := (SELECT CEIL(Par_NumHuellas / Par_RegPorPagina));
        SET Par_NumPaginas := IFNULL(Par_NumPaginas, Entero_Cero);

        IF (Par_NumPaginas = Entero_Cero) THEN
            SET Par_NumErr	:= '003';
			SET Par_ErrMen	:= 'Ha ocurrido un error al calcular el numero de paginas.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Datos devueltos correctamente.';
		SET Var_Control := Cadena_Vacia;

    END ManejoErrores;
    -- Finaliza Bloque de Manejo de Errores

    IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen					 AS ErrMen,
				Var_Control					 AS Control,
				Par_NumHuellas               AS NumeroHuellas,
                Par_RegPorPagina             AS RegPorPagina ,
                Par_NumPaginas               AS NumeroPaginas;
	END IF;

END TerminaStore$$