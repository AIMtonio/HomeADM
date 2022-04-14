-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOWSLIS`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOWSLIS`(




	Par_PromotorID				INT(10),
	Par_NumLis				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN


	DECLARE Lis_CtaAhoWS		INT;

	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(4);


	SET Lis_CtaAhoWS			:=  1;

	SET Estatus_Activo			:= 'A';
	SET Cadena_Vacia			:= '';
	SET Decimal_Cero			:= 0.00;


if(Par_NumLis = Lis_CtaAhoWS) then
	SELECT	(cta.CuentaAhoID) AS Num_Cta,
			cta.TipoCuentaID AS Id_Cuenta,
			cte.CLienteID    AS Num_Socio,
			IFNULL(cta.Saldo,Decimal_Cero)       AS SaldoTot,
			IFNULL(cta.SaldoDispon,Decimal_Cero) AS SaldoDisp,
			Cadena_Vacia	 AS Parametros
	FROM CLIENTES AS cte
		INNER JOIN PROMOTORES as ptor
				ON cte.PromotorActual = ptor.PromotorID
					AND ptor.Estatus =  'A'
		INNER JOIN CUENTASAHO AS cta
				ON cta.ClienteID = cte.CLienteID  and cta.Estatus = 'A'
	WHERE ptor.PromotorID = Par_PromotorID
	 and cte.Estatus = Estatus_Activo;
end if;

END TerminaStore$$