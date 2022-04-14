-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARARESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARARESLIS`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARARESLIS`(
#SP DE ACLARACION DE TARJETAS LISTA
    Par_ReporteID       	CHAR(15), 			-- Parametro de reporte ID
    Par_NumLis 		        TINYINT UNSIGNED,	-- Parametro de numero de lista

    Par_EmpresaID	        INT(11),			-- Parametro de Auditoria
    Aud_Usuario     	    INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID		    VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Constantes

	DECLARE Cadena_Vacia   	 CHAR(1);			-- cadena vacia
	DECLARE Fecha_Vacia    	 DATE;				-- fecha vacia
	DECLARE Entero_Cero		 INT(11);			-- entero cero
	DECLARE Lis_Principal    INT(11);			-- lista principal
	DECLARE Lis_CreResultado INT(11);			-- lista credito resultado
    DECLARE TipoCred		 CHAR(1);			-- tipo credito
    DECLARE TipoDeb			 CHAR(1);			-- tipo debito
-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';              -- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero			:= 0;               -- Entero Cero
	SET Lis_Principal		:= 4;               -- Tipo de Lista Principal
    SET Lis_CreResultado    := 6;				-- Lista de resultado Tarj. Credito
    SET TipoCred			:= 'C';				-- Tipo Tarjeta Credito
    SET TipoDeb				:= 'D';				-- Tipo Tarjeta Debito


    IF(Par_NumLis = Lis_Principal) THEN
		SELECT TAR.ReporteID, TARJ.TarjetaDebID
            FROM TARDEBACLARACION AS TAR LEFT JOIN TARJETADEBITO AS TARJ ON TAR.TarjetaDebID=TARJ.TarjetaDebID
            WHERE TAR.TipoTarjeta = TipoDeb AND TAR.ReporteID LIKE CONCAT('%',Par_ReporteID,'%') OR
                TARJ.NombreTarjeta LIKE CONCAT('%',Par_ReporteID,'%') OR
				TARJ.ClienteID LIKE CONCAT('%',Par_ReporteID,'%') OR
                TARJ.NombreTarjeta LIKE CONCAT('%',Par_ReporteID,'%')
		LIMIT 0, 15;

    END IF;

	IF(Par_NumLis = Lis_CreResultado) THEN
        SELECT TAR.ReporteID, TARJ.TarjetaCredID
            FROM TARDEBACLARACION AS TAR LEFT JOIN TARJETACREDITO AS TARJ ON TAR.TarjetaDebID=TARJ.TarjetaCredID
            WHERE TAR.TipoTarjeta = TipoCred AND TAR.ReporteID LIKE CONCAT('%',Par_ReporteID,'%') OR
                TARJ.NombreTarjeta LIKE CONCAT('%',Par_ReporteID,'%') OR
				TARJ.ClienteID LIKE CONCAT('%',Par_ReporteID,'%') OR
                TARJ.NombreTarjeta LIKE CONCAT('%',Par_ReporteID,'%')
		LIMIT 0, 15;

    END IF;


END TerminaStore$$