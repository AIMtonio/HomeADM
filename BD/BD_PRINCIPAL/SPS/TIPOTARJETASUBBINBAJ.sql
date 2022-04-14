-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOTARJETASUBBINBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOTARJETASUBBINBAJ`;
DELIMITER $$

CREATE PROCEDURE `TIPOTARJETASUBBINBAJ`(
-- SP PARA LISTAR EL TIPO DE TARJETA
    Par_TarBinParamsID  INT(11),            -- Parametro de Tipo Tarjeta
    Par_NumSubBIN       INT(11),            -- Parametro de Tipo Tarjeta

    Par_Salida            CHAR(1),
    INOUT Par_NumErr      INT,
    INOUT Par_ErrMen      VARCHAR(400),

    Par_EmpresaID       INT(11),            -- Parametro de Auditoria
    Aud_Usuario         INT(11),            -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),        -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal        INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)          -- Parametro de Auditoria

)
TerminaStore:BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_TipoCuenta      INT(11);        -- Variable de Tipo cuenta
-- Declaracion de Constantes
DECLARE Entero_Cero         INT(11);        -- Entero Cero
DECLARE Cadena_Vacia        CHAR(1);        -- cadena Vacia
DECLARE EstatusA            CHAR(1);        -- Estatus Activo
DECLARE EstatusI            CHAR(1);        -- Estatus Inactivo
DECLARE Var_Credito         VARCHAR(2);
DECLARE Var_Debito          VARCHAR(2);
DECLARE SalidaSI        CHAR(1);


-- Asiganacion de Constantes
SET Entero_Cero         := 0;   -- ENTERO En cero
SET Cadena_Vacia        := '';  -- cadena vacia
SET EstatusA            :='A';
SET EstatusI            :='I';
SET SalidaSI          := 'S';

SET Var_Credito :=(
    SELECT count(TarjetaCredID) AS Cred FROM microfinDesa.TARJETACREDITO  WHERE TarjetaCredID like CONCAT(Par_TarBinParamsID,Par_NumSubBIN,"%"));
SET  Var_Debito :=(
    SELECT count(TarjetaDebID) AS Ded FROM microfinDesa.TARJETADEBITO WHERE TarjetaDebID like CONCAT(Par_TarBinParamsID,Par_NumSubBIN,"%"));

IF(Var_Credito > 0 || Var_Debito > 0)THEN
    UPDATE TIPOTARJETADEB SET   Estatus = EstatusA WHERE TarBinParamsID=Par_TarBinParamsID AND  NumSubBIN = Par_NumSubBIN;
ELSE
    DELETE FROM TIPOTARJETADEB
        WHERE TarBinParamsID=Par_TarBinParamsID AND     NumSubBIN = Par_NumSubBIN;
END IF;

  SET Par_NumErr := '0';
  SET Par_ErrMen := 'Archivo Eliminado.' ;

 IF(Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                varControl AS 'TarBinParamsID',
                Par_TarBinParamsID AS consecutivo;
    END IF;

END TerminaStore$$
