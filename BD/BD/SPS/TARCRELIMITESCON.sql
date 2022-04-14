-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCRELIMITESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCRELIMITESCON`;DELIMITER $$

CREATE PROCEDURE `TARCRELIMITESCON`(
#SP DE CONSULTA DE LIMITES DE TARJETA DE CREDITO
    Par_TarjetaCredID        CHAR(16),		-- Parametro de tarjeta credito ID
    Par_NumCon              INT(11),		-- Parametro de numero de consulta

    Par_EmpresaID           INT(11),		-- Parametro de Auditoria
    Aud_Usuario             INT(11),		-- Parametro de Auditoria
    Aud_FechaActual         DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal            INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)		-- Parametro de Auditoria
	)
TerminaStore: BEGIN
	-- declaracion de variables
	DECLARE Var_EstatusExis     CHAR(1);	-- Parametro de Estatus Existente
	-- Declaracion de Cosntantes
	DECLARE Con_Principal  		INT;		-- Consulta principal
	DECLARE Cadena_Vacia	 	CHAR(1);	-- cadena vacia
	DECLARE Entero_Cero			INT;		-- entero cero

	-- Asignacion de Constantes
	SET Con_Principal       :=1;    -- Consulta Principal
	SET Cadena_Vacia        :='';
	SET Entero_Cero         :=0;
	-- variable de estatus

    -- 1 Consulta Pricipal
    IF(Par_NumCon = Con_Principal) THEN
        SELECT
            NoDisposiDia,	DisposiDiaNac,	NumConsultaMes,	DisposiMesNac,		ComprasDiaNac,
			ComprasMesNac,	BloquearATM,	BloquearPOS,	BloquearCashBack,	Vigencia,
			AceptaOpeMoto
        FROM TARCRELIMITES
        WHERE TarjetaCredID =Par_TarjetaCredID;
    END IF;

END TerminaStore$$