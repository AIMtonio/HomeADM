-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANALISTASASIGNACIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANALISTASASIGNACIONBAJ`;
DELIMITER $$

CREATE PROCEDURE `ANALISTASASIGNACIONBAJ`(
  Par_ProductoID               INT(11),    -- ID de producto
  Par_TipoAsignacionID        INT(11),     -- ID tipo de asignacion

  Par_Salida            CHAR(1),
  INOUT Par_NumErr      INT,
  INOUT Par_ErrMen      VARCHAR(400),

  -- Parametros de Auditoria
  Par_EmpresaID     INT(11),        -- Parametro de auditoria ID de la empresa
  Aud_Usuario       INT(11),        -- Parametro de auditoria ID del usuario
  Aud_FechaActual     DATETIME,     -- Parametro de auditoria Feha actual
  Aud_DireccionIP     VARCHAR(15),  -- Parametro de auditoria Direccion IP
  Aud_ProgramaID      VARCHAR(50),  -- Parametro de auditoria Programa
  Aud_Sucursal      INT(11),        -- Parametro de auditoria ID de la sucursal
  Aud_NumTransaccion    BIGINT(20)  -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN


DECLARE Entero_Cero     INT;       -- Entero cero
DECLARE SalidaSI        CHAR(1);   -- Salida si
DECLARE	Var_Control     CHAR(15);        -- Control de Retorno en pantalla


SET Entero_Cero       := 0;        -- valor cero
SET SalidaSI          := 'S';      -- valor S de si


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ANALISTASASIGNACIONBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

-- Elimina todos los registros que posteriormente seran dados de alta en la pantalla
DELETE FROM ANALISTASASIGNACION
    where TipoAsignacionID =  Par_TipoAsignacionID and ProductoID=Par_ProductoID;

  


IF(Par_Salida = SalidaSI) THEN
  SELECT '000' AS NumErr ,
      'Catalogo Asignacion Grabado Exitosamente.' AS ErrMen,
      'usuarioID' AS control,
      '0' AS consecutivo;
ELSE
  SET Par_NumErr := '0';
  SET Par_ErrMen := 'Catalogo Asignacion Grabado Exitosamente.';
  SET Var_Control:= 'analistasAsigID' ;
END IF;

END ManejoErrores; 

END TerminaStore$$