-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERARCHIVOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERARCHIVOBAJ`;DELIMITER $$

CREATE PROCEDURE `USUARIOSERARCHIVOBAJ`(
  Par_UsuarioSerArchiID   INT(11),
  Par_UsuarioID         INT,
  Par_TipoDocumen       VARCHAR(45),

  Par_Salida            CHAR(1),
    INOUT Par_NumErr      INT,
  INOUT Par_ErrMen      VARCHAR(400),

  Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Estatus_Activo  CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE SalidaSI        CHAR(1);


SET Estatus_Activo    := 'A';
SET Cadena_Vacia      := '';
SET Fecha_Vacia       := '1900-01-01';
SET Entero_Cero       := 0;
SET SalidaSI          := 'S';

DELETE FROM USUARIOSERARCHIVO
   where UsuarioSerArchiID =  Par_UsuarioSerArchiID;

IF(Par_Salida = SalidaSI) THEN
  SELECT '000' AS NumErr ,
      'Archivo Eliminado' AS ErrMen,
      'usuarioID' AS control,
      '0' AS consecutivo;
ELSE
  SET Par_NumErr := '0';
  SET Par_ErrMen := 'Archivo Eliminado.' ;
END IF;


END TerminaStore$$