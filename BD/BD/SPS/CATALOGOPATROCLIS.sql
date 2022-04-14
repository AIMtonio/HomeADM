-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOPATROCLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOPATROCLIS`;
DELIMITER $$

CREATE PROCEDURE `CATALOGOPATROCLIS`(
-- SP PARA LISTAR EL TIPO DE TARJETA
	Par_PatrocinadorID  INT(11),			-- Parametro de Tipo Tarjeta

    Par_NumLis          TINYINT UNSIGNED,	-- Parametro de numero lists
    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria

)
TerminaStore:BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_TipoCuenta  	INT(11);		-- Variable de Tipo cuenta
-- Declaracion de Constantes
DECLARE Entero_Cero    		INT(11);		-- Entero Cero
DECLARE Cadena_Vacia    	CHAR(1);		-- cadena Vacia
DECLARE EstatusA	        CHAR(1);		-- Estatus Activo
DECLARE EstatusI	        CHAR(1);		-- Estatus Inactivo
DECLARE Lis_Principal       INT(11);        -- Lista Principal


-- Asiganacion de Constantes
SET Entero_Cero         := 0;	-- ENTERO En cero
SET Cadena_Vacia        := '';	-- cadena vacia
SET EstatusA            :='A';
SET EstatusI            :='I';
SET Lis_Principal       := 1;    -- actualizacion para asociar una tarjeta a una cuentacte

SET Aud_FechaActual := NOW();

    IF(Par_NumLis = Lis_Principal) THEN
        SELECT PatrocinadorID, NombrePatroc
            FROM CATALOGOPATROCINADOR;
    END IF;

END TerminaStore$$
