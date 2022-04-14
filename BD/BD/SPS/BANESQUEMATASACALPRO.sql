-- BANESQUEMATASACALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANESQUEMATASACALPRO`;
DELIMITER $$


CREATE PROCEDURE `BANESQUEMATASACALPRO`(

    Par_SucursalID      	INT(11),
    Par_ProdCreID       	INT(11),
    Par_NumCreditos			INT(11),
    Par_Monto           	DECIMAL(12,2),
    Par_Califi         		VARCHAR(45),

	OUT Par_TasaFija		DECIMAL(12,4),
	Par_PlazoID				VARCHAR(200),
    Par_EmpresaNomina		INT(11),
    Par_ConvenioNominaID	BIGINT UNSIGNED,
    OUT Par_NivelID			INT(11),
    Par_Salida          	CHAR(1),

    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),
    Par_EmpresaID			INT(11),
    Aud_Usuario				INT(11),
    Aud_FechaActual			DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Var_FechaSistema    DATETIME;
	DECLARE Var_Control					VARCHAR(50);



    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Cero             INT;
    DECLARE SalidaSI                CHAR(1);
    DECLARE SalidaNO                CHAR(1);
    DECLARE Decimal_Cero            DECIMAL;


    SET Cadena_Vacia            := '';
    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Cero             := 0;
    SET SalidaSI                := 'S';
    SET SalidaNO                := 'N';
    SET Decimal_Cero            := 0.00;


    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := Cadena_Vacia;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			'esto le ocasiona. Ref: SP-BANESQUEMATASACALPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		CALL ESQUEMATASACALPRO(Par_SucursalID,			Par_ProdCreID,		Par_NumCreditos,		Par_Monto,				Par_Califi,
								Par_TasaFija,			Par_PlazoID,		Par_EmpresaNomina,		Par_ConvenioNominaID,   Par_NivelID,
                                SalidaNO,               Par_NumErr,         Par_ErrMen,             Par_EmpresaID,      	Aud_Usuario,
                                Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       	Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Par_TasaFija := Decimal_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_TasaFija	:=IFNULL(Par_TasaFija,Decimal_Cero);

	END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                Par_TasaFija AS ValorTasa,
                Cadena_Vacia AS control,
                Entero_Cero AS consecutivo;
    END IF;

END TerminaStore$$
