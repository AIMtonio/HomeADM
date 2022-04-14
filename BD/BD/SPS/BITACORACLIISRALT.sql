-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACLIISRALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACLIISRALT`;DELIMITER $$

CREATE PROCEDURE `BITACORACLIISRALT`(



	Par_Fecha				DATETIME,
    INOUT Par_NumErr		INT,
    INOUT Par_ErrMen		VARCHAR(400),
    Par_Salida				CHAR(1),
    Par_EmpresaID			INT,
    Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

		)
TerminaStore: BEGIN

DECLARE Var_Fecha		DATE;
DECLARE Var_Contador	INT;

DECLARE SalidaSI		CHAR(1);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Entero_Cero		INT;

SET	SalidaSI	:= 'S';
SET Cadena_Vacia:= '';
SET Fecha_Vacia := '1900-01-01';
SET Entero_Cero	:= 0;
    ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		set Par_NumErr = 999;
		set Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-BITACORACLIISRALT");
		END;

	SELECT Fecha INTO Var_Fecha
      FROM BITACORACLIISR
		WHERE Fecha=Par_Fecha;
	SELECT TipoInstrumentoID INTO Var_Contador
      FROM HISCLIENTESISR
		LIMIT 1;

    SET Var_Contador:= IFNULL(Var_Contador,Entero_Cero);
    SET Var_Fecha	:= IFNULL(Var_Fecha,Fecha_Vacia);

   IF Var_Fecha = Par_Fecha  THEN
		set Par_NumErr = 1;
		set Par_ErrMen = CONCAT("El proceso ya fue Ejecutado  el Día de Hoy");
    LEAVE ManejoErrores;
    end if;
    IF  Var_Contador=Entero_Cero THEN
		set Par_NumErr = 2;
		set Par_ErrMen = CONCAT("El Registro esta vacio");
    LEAVE ManejoErrores;
    end if;

    INSERT INTO BITACORACLIISR
		(Fecha, 		Empresa, 	Usuario, 			FechaActual, 	DireccionIP,
        ProgramaID, 	Sucursal, 	NumTransaccion)
		VALUES   (Par_Fecha,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,
				  Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	TRUNCATE HISCLIENTESISR;

    SET Par_NumErr := 0;
	SET Par_ErrMen := 	CONCAT("Proceso Terminado con Éxito");

	END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
                Cadena_Vacia AS control;
	END if;


END TerminaStore$$