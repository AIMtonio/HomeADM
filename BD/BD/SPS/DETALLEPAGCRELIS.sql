-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGCRELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGCRELIS`;DELIMITER $$

CREATE PROCEDURE `DETALLEPAGCRELIS`(
    Par_CreditoID   BIGINT(12),
    Par_FechaPago   DATE,
    Par_Transaccion BIGINT,
    Par_NumLis      TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE  Lis_RepTicket	INT;
DECLARE  Lis_RepTicketAgro	INT;

SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Lis_RepTicket   := 1;
SET Lis_RepTicketAgro   := 2;


IF(Par_NumLis = Lis_RepTicket) THEN

	SELECT DISTINCT(CreditoID) AS Credito
        FROM	 DETALLEPAGCRE Det
         WHERE Det.FechaPago = Par_FechaPago
           AND Det.NumTransaccion = Par_Transaccion;
END IF;

IF(Par_NumLis = Lis_RepTicketAgro) THEN

	(SELECT DISTINCT(CreditoID) AS Credito
        FROM	 DETALLEPAGCRE Det
         WHERE Det.FechaPago = Par_FechaPago
           AND Det.NumTransaccion = Par_Transaccion)
	UNION
    (SELECT DISTINCT(CreditoID) AS Credito
        FROM	 DETALLEPAGCRECONT Dcon
         WHERE Dcon.FechaPago = Par_FechaPago
           AND Dcon.NumTransaccion = Par_Transaccion);

END IF;

END TerminaStore$$