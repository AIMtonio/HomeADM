-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALIFICACREDITOSOCAPPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALIFICACREDITOSOCAPPRO`;DELIMITER $$

CREATE PROCEDURE `CALIFICACREDITOSOCAPPRO`(



    Par_Fecha           DATETIME,


    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN


	DECLARE Var_LimiteExpuesto  INT;
	DECLARE Var_TipoInstitucion CHAR(2);


	DECLARE Entero_Cero     INT;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Decimal_Cero    DECIMAL(12,2);
	DECLARE EstatusActiva   CHAR(1);
	DECLARE TipoExpuesto    CHAR(1);

    DECLARE SinCalificacion CHAR(2);
	DECLARE CreReestructura	CHAR(1);
	DECLARE CreRenovacion	CHAR(1);
	DECLARE Esta_Desembolso CHAR(1);


	SET Entero_Cero     	:= 0;
	SET Cadena_Vacia		:= '';
	SET Decimal_Cero     	:= 0.00;
	SET EstatusActiva   	:= 'A';
	SET TipoExpuesto    	:= 'E';

    SET SinCalificacion 	:= 'SC';
	SET CreReestructura		:= 'R';
	SET CreRenovacion		:= 'O';
	SET Esta_Desembolso		:= 'D';


	SELECT  TipoInstitucion,    	LimiteExpuesto
	INTO 	Var_TipoInstitucion, 	Var_LimiteExpuesto
	FROM PARAMSCALIFICA;


	UPDATE SALDOSCREDITOS sal
		INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = sal.DestinoCreID
		INNER JOIN PORCRESPERIODO por ON CASE WHEN IFNULL(sal.DiasAtraso, Entero_Cero) < Entero_Cero
													THEN Entero_Cero
											  ELSE sal.DiasAtraso
										 END
											BETWEEN por.LimInferior AND por.LimSuperior AND Des.Clasificacion = por.Clasificacion
		LEFT JOIN CALPORRANGO cal ON IFNULL(cal.TipoInstitucion, por.TipoInstitucion) = por.TipoInstitucion
										AND (CASE WHEN IFNULL(por.PorResCarSReest, 0.1) <= Entero_Cero
														THEN 0.1
														ELSE IFNULL(por.PorResCarSReest, 0.1)
												  END ) > cal.LimInferior
										AND por.PorResCarSReest <= cal.LimSuperior
										AND por.Estatus = EstatusActiva
										AND Des.Clasificacion = cal.Clasificacion
	   LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = sal.CreditoID AND Res.EstatusReest = Esta_Desembolso

	SET sal.Calificacion  = IFNULL(cal.Calificacion, SinCalificacion),
		sal.PorcReserva   = IFNULL( CASE WHEN IFNULL(Res.Origen, Cadena_Vacia) = Cadena_Vacia
											THEN por.PorResCarSReest
										 WHEN (IFNULL(Res.Origen, Cadena_Vacia) = CreReestructura  OR IFNULL(Res.Origen, Cadena_Vacia) = CreRenovacion)
											THEN por.PorResCarReest
									END, Decimal_Cero)

	WHERE   sal.FechaCorte  	= Par_Fecha
		  AND   por.TipoInstitucion = Var_TipoInstitucion
		  AND   por.Estatus     = EstatusActiva
		  AND   por.TipoRango   = TipoExpuesto
		  AND   cal.Estatus     = EstatusActiva;

END TerminaStore$$