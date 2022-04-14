-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOAJUSTE
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOAJUSTE`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOAJUSTE`(


		)
TerminaStore:BEGIN


CREATE TEMPORARY TABLE CUENTASCHECKIN
	(CuentaAhoID bigint(12),
	MontoBloqueo decimal(14,2),
	MontoDesbloqueo decimal(14,2)
);



insert into CUENTASCHECKIN(
		select CuentaAhoID,0.0, sum(MontoBloq)
			from BLOQUEOS
			where TiposBloqID = 3
			and NatMovimiento = 'D'
			group by CuentaAhoID) ;

update CUENTASCHECKIN  CHE set
	MontoBloqueo = (select  sum(MontoBloq)
					from BLOQUEOS BLO
					where TiposBloqID = 3
					and NatMovimiento = 'B'
					and CHE.CuentaAhoID = 	BLO.CuentaAhoID
					group by BLO.CuentaAhoID );



select * from CUENTASCHECKIN;

END TerminaStore$$