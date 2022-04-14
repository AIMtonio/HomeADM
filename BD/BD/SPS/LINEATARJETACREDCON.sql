-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEATARJETACREDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEATARJETACREDCON`;DELIMITER $$

CREATE PROCEDURE `LINEATARJETACREDCON`(
-- SP PARA LA CONSULTA DE LINEA DE CREDITO
    Par_LineatarCredID		INT(11),		-- Linea de credito
    Par_ClienteID           INT(11),     	-- Cliente
    Par_TipoTarjetaCred		INT(11), 		-- Tipo de tarjeta
    Par_NumCon              TINYINT UNSIGNED,-- Numero de Consulta

    Par_EmpresaID           INT(11),		-- Auditoria
    Aud_Usuario             INT(11), 		-- Auditoria
    Aud_FechaActual         DATETIME, 		-- Auditoria
    Aud_DireccionIP         VARCHAR(15), 	-- Auditoria
    Aud_ProgramaID          VARCHAR(50), 	-- Auditoria
    Aud_Sucursal            INT(11), 		-- Auditoria
    Aud_NumTransaccion      BIGINT(20) 		-- Auditoria
	)
TerminaStore: BEGIN
-- Declaracion de Constantes
DECLARE Fecha_Vacia			DATE;
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Entero_Cero     	INT;
DECLARE Con_Principal  		INT;		   -- Consulta principal
DECLARE Con_UltimoCorte		INT;		   -- Consulta de ultimo corte
DECLARE DesLinea			VARCHAR(20);   -- Descripcion de la linea

-- Asignacion de Constantes
SET Fecha_Vacia			:='1900-01-01';
SET Cadena_Vacia        :='';
SET Entero_Cero         :=0;
SET Con_Principal       :=1;
SET Con_UltimoCorte		:=2;
SET DesLinea            :='LINEA DE CREDITO';



    -- 1 Consulta Pricipal
    IF(Par_NumCon = Con_Principal) THEN
        SELECT LIN.LineatarCredID, 		DesLinea AS Descripcion, 		LIN.TipoCorte, 			LIN.DiaCorte, 		LIN.TipoPago,
			   LIN.DiaPago,				TAR.TarjetaCredID, 				LIN.CuentaClabe,		TAR.Estatus
        FROM LINEATARJETACRED AS LIN
        INNER JOIN TARJETACREDITO AS TAR ON LIN.ClienteID = TAR.ClienteID AND LIN.LineaTarCredID = TAR.LineaTarCredID
        WHERE LIN.ClienteID = Par_ClienteID AND LIN.TipoTarjetaDeb=Par_TipoTarjetaCred;
    END IF;

    -- 2 Consulta Corte
    IF(Par_NumCon = Con_UltimoCorte) THEN
        SELECT LIN.SaldoInicial, 		LIN.PagoNoGenInteres, 		LIN.PagoMinimo, 			LIN.SaldoCorte, 		LIN.FechaProxCorte
        FROM LINEATARJETACRED AS LIN
        INNER JOIN TARJETACREDITO AS TAR ON LIN.ClienteID = TAR.ClienteID AND LIN.LineaTarCredID = TAR.LineaTarCredID
        WHERE LIN.ClienteID = Par_ClienteID AND LIN.TipoTarjetaDeb=Par_TipoTarjetaCred;
    END IF;



END TerminaStore$$