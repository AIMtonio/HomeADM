-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERACREDIDCNBVMASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERACREDIDCNBVMASIVOPRO`;DELIMITER $$

CREATE PROCEDURE `GENERACREDIDCNBVMASIVOPRO`(
	/* SP Para generar los Identificadores de Credito masivo
       Cuando la institucion no ha registrado sus creditos a la CNBV*/
	Par_Salida					CHAR(1),
    INOUT	Par_NumErr 			INT,
	INOUT	Par_ErrMen  		VARCHAR(400),

    Par_EmpresaID				INT,
    Par_Usuario 				INT(11) ,
    Par_FechaActual 			DATETIME,
    Par_DireccionIP 			VARCHAR(15),
    Par_ProgramaID 				VARCHAR(50),
    Par_SucursalID 				INT(11) ,
    Par_NumTransaccion 			BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_CreditoIDCNBV	VARCHAR(29);  -- Identificador CNBV generado
DECLARE Var_CreditoID 		BIGINT;		  -- ID de creditoa generar
DECLARE Var_LineaCreditoID	BIGINT;		  -- ID de la linea de credito a generar
DECLARE Var_TipoProd		INT; 		  -- Tipo producto de Credito ( Linea - Credito)
DECLARE Var_Control			VARCHAR(50);  -- Variable de control

DECLARE Salida_NO			CHAR(1);
DECLARE Salida_SI 			CHAR(1);
DECLARE Fecha_Vacia 		DATE;
DECLARE Entero_Cero 		INT;
DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Tipo_Credito 		INT;		 -- Tipo de producto - Credito
DECLARE Tipo_Linea	 		INT; 		 -- Tipo de producto - Linea

-- CURSOR para recorrer todos los creditos
DECLARE  	CursorCreditos  CURSOR FOR
	SELECT 	CreditoID
		FROM CREDITOS
        ORDER BY FechaInicio ASC;

-- CURSOR para recorrer todas las linea de credito
DECLARE  	CursorLineasCreditos  CURSOR FOR
	SELECT 	LineaCreditoID
		FROM LINEASCREDITO
        ORDER BY FechaAutoriza ASC;

SET Cadena_Vacia 	:= '';
SET Salida_NO 		:= 'N';
SET Salida_SI	 	:= 'S';
SET Fecha_Vacia		:= '1900-01-01';
SET Entero_Cero		:= 0;
SET Tipo_Credito	:= 2; 	-- Tipo de producto - Credito
SET Tipo_Linea	 	:= 1; 	-- Tipo de producto - Linea
SET Var_TipoProd 	:= 2;	-- Credito


ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERACREDIDCNBVMASIVOPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;


        -- Limpiar tabla
        DELETE FROM  CREDITOSCLIENTES;

        INSERT INTO CREDITOSCLIENTES
		SELECT ClienteID,			Entero_Cero,		Fecha_Vacia,		Par_EmpresaID,
			   Par_Usuario,			Par_FechaActual,	Par_DireccionIP,
			   Par_ProgramaID,		Par_SucursalID,		Par_NumTransaccion FROM CLIENTES;



		OPEN  CursorCreditos;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CursorCreditos  INTO Var_CreditoID;

					CALL GENERACREDIDCNBVPRO(
					Var_CreditoID,			Var_TipoProd,		Salida_NO,		Par_NumErr,			Par_ErrMen,
					Var_CreditoIDCNBV,		Par_EmpresaID,		Par_Usuario,	Par_FechaActual,	Par_DireccionIP,
					Par_ProgramaID,			Par_SucursalID,		Par_NumTransaccion);

				END LOOP;
			END;
		CLOSE CursorCreditos;

		SET Var_TipoProd := Tipo_Linea; -- Lineas Credito

		OPEN  CursorLineasCreditos;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CursorLineasCreditos  INTO Var_LineaCreditoID;

					CALL GENERACREDIDCNBVPRO(
					Var_LineaCreditoID,			Var_TipoProd,		Salida_NO,		Par_NumErr,			Par_ErrMen,
					Var_CreditoIDCNBV,		Par_EmpresaID,		Par_Usuario,	Par_FechaActual,	Par_DireccionIP,
					Par_ProgramaID,			Par_SucursalID,		Par_NumTransaccion);


				END LOOP;
			END;
		CLOSE CursorLineasCreditos;


		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Identificadores CNBV Generados Exitosamente';

END ManejoErrores;


IF Par_Salida = Salida_SI  THEN

	SELECT Par_NumErr AS NumErr,
		   Par_ErrMen AS ErrMen,
           IFNULL(Var_Control,Entrero_Cero) AS control;


END IF;

END TerminaStore$$