-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGC0922BAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROREGC0922BAJ`;DELIMITER $$

CREATE PROCEDURE `REGISTROREGC0922BAJ`(
/*=======================================================================
--------- SP QUE ANADE UN REGISTRO PARA EL REGULATORIO C0922 -----------
========================================================================*/

	Par_Anio			  INT,				-- Ano  del reporte
	Par_Mes				  INT,				-- Mes  del reporte

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
					concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-REGISTROREGC0922BAJ');
		SET Var_Control := 'SQLEXCEPTION';
    END;

	DELETE FROM REGISTROREGC0922
    WHERE Anio = Par_Anio
    AND   Mes  = Par_Mes;

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := CONCAT('Registros Eliminados Correctamente: ');
    SET Var_Control := 'registroID';

END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
     SELECT Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
 END IF;

END TerminaStore$$