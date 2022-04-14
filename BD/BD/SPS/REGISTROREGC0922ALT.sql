-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGC0922ALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROREGC0922ALT`;DELIMITER $$

CREATE PROCEDURE `REGISTROREGC0922ALT`(
/*=======================================================================
--------- SP QUE ANADE UN REGISTRO PARA EL REGULATORIO C0922 -----------
========================================================================*/

	Par_Anio			  INT,				-- Ano  del reporte
	Par_Mes				  INT,				-- Mes  del reporte
	Par_ClasfContable	  VARCHAR(20), 	 	-- Clasificacion contable
	Par_Nombre			  VARCHAR(250),		-- Nombre del beneficiario
	Par_Puesto			  VARCHAR(60),		-- nombre del puesto del beneficiario
	Par_TipoPercepcion 	  INT,				-- Clave del tipo de percepcion
	Par_Descripcion		  VARCHAR(60),		-- Descripcion del movimiento
	Par_Dato			  DECIMAL(23,2),	-- Monto del Movimiento

	Par_Salida              CHAR(1),		-- Parametro de salida
	INOUT Par_NumErr        INT(11), 		-- Numero de error
	INOUT Par_ErrMen        VARCHAR(400),   -- Mensaje de salida

	Par_EmpresaID           INT(11),		-- Auditoria
	Aud_Usuario             INT(11),		-- Auditoria
	Aud_FechaActual         DATETIME,		-- Auditoria
	Aud_DireccionIP         VARCHAR(15),	-- Auditoria
	Aud_ProgramaID          VARCHAR(50),	-- Auditoria
	Aud_Sucursal            INT(11),		-- Auditoria
	Aud_NumTransaccion      BIGINT(20) 		-- Auditoria
)
TerminaStore: BEGIN
  -- Declaracion de Variables
  DECLARE Var_Control       VARCHAR(100); -- Campo de control
  DECLARE Var_Periodo       VARCHAR(6);	-- Periodo del reporte
  DECLARE Var_Destino       VARCHAR(8);  -- Variable para validar que un destino de pagos existe
  DECLARE Var_Plazo         VARCHAR(8);  -- Variable para validar que un plazo existe
  DECLARE Var_TipoCred      VARCHAR(8);  -- Variable para validar que un tipo de creditos existe
  DECLARE Var_TipoGaran     VARCHAR(8);  -- Variable para validar que un tipo de garantia existe
  DECLARE Var_TipoPres      VARCHAR(8);  -- Variable para validar que tipo de prestamista existe
  DECLARE Var_Consecutivo   INT; 		 -- Consecutivo de Registro
  DECLARE Var_Formulario    CHAR(4); 	 -- Clave del Regulatorio
  DECLARE Var_ClaveEntidad  VARCHAR(6);  -- Clave de la entidad

  -- Declaracion de Constantes
  DECLARE SalidaSI          CHAR(1);		-- Constante de salida
  DECLARE Entero_Cero       INT;			-- Entero cero
  DECLARE Decimal_Cero      DECIMAL(14,2);	-- DECIMAL cero
  DECLARE Cadena_Vacia      CHAR;			-- Cadena vacia
  DECLARE Entero_Uno        INT;			-- Entero uno
  DECLARE Fecha_Vacia		DATE;			-- Fecha vacia

  -- Asignacion de Constantes
  SET SalidaSI            :='S';
  SET Entero_Cero         :=0;
  SET Decimal_Cero        :=0.0;
  SET Cadena_Vacia        :='';
  SET Entero_Uno          := 1;
  SET Fecha_Vacia		  := '1900-01-01';

  ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
					concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-REGISTROREGC0922ALT');
		SET Var_Control := 'SQLEXCEPTION';
    END;


    SELECT (MAX(RegistroID)+Entero_Uno)
    INTO Var_Consecutivo
      FROM  REGISTROREGC0922
      WHERE Anio = Par_Anio
      AND   Mes  = Par_Mes;

    SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Uno);


     IF IFNULL(Par_ClasfContable ,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 01;
		SET Par_ErrMen  := 'La clasificacion Contable Esta Vacia.';
		SET Var_Control := CONCAT('clasfContable',Var_Consecutivo);
		LEAVE ManejoErrores;
	  END IF;


      IF IFNULL(Par_Nombre ,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 02;
		SET Par_ErrMen  := 'El nombre esta Vacio.';
		SET Var_Control := CONCAT('nombre',Var_Consecutivo);
		LEAVE ManejoErrores;
	  END IF;

       IF IFNULL(Par_Puesto ,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 03;
		SET Par_ErrMen  := 'El Puesto esta Vacio.';
		SET Var_Control := CONCAT('puesto',Var_Consecutivo);
		LEAVE ManejoErrores;
	  END IF;



	  IF IFNULL(Par_Descripcion ,Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr  := 05;
		SET Par_ErrMen  := 'La Descripcion esta vacia.';
		SET Var_Control := CONCAT('descripcion',Var_Consecutivo);
		LEAVE ManejoErrores;
	  END IF;

      IF IFNULL(Par_Dato ,Decimal_Cero) = Decimal_Cero THEN
		SET Par_NumErr  := 06;
		SET Par_ErrMen  := 'El Monto esta Vacio.';
		SET Var_Control := CONCAT('dato',Var_Consecutivo);
		LEAVE ManejoErrores;
	  END IF;



	  INSERT INTO REGISTROREGC0922
		(Anio, 			Mes,				RegistroID, 		ClasfContable, 			Nombre,
         Puesto, 		TipoPercepcion, 	Descripcion, 		Dato,					EmpresaID,
         Usuario, 		FechaActual, 		DireccionIP, 		ProgramaID, 			Sucursal,
         NumTransaccion
		)
		VALUES
		(
         Par_Anio,			Par_Mes,			Var_Consecutivo,	Par_ClasfContable,		Par_Nombre,
         Par_Puesto,     	Par_TipoPercepcion, Par_Descripcion,    Par_Dato,
		 Par_EmpresaID,     Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP, 		Aud_ProgramaID,
         Aud_Sucursal,      Aud_NumTransaccion);

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := CONCAT('Registro Agregado Correctamente: ',Var_Consecutivo);
    SET Var_Control := 'registroID';

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
     SELECT Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
 END IF;

END TerminaStore$$