-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOSAGROREP`;

DELIMITER $$
CREATE PROCEDURE `CRECASTIGOSAGROREP`(
	-- Store Procedure de Cartera Castigada para el Modulo Agro
	-- Cartera Agro --> Reportes --> Cartera Catigada
	Par_FechaInicio			DATE,			-- Parametro de Fecha de Inicio del Reporte
	Par_FechaFin 			DATE, 			-- Parametro de Fecha de Fin del Reporte
	Par_Sucursal			INT(11), 		-- Parametro de Sucursal
	Par_ProductoCre			INT(11), 		-- Parametro de Producto de Crédito
	Par_Promotor   			INT(11), 		-- Parametro de Promotor
	Par_MotivoCastigoID		INT(11), 		-- Parametro de Motivo de Castigo

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATE,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT,			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia 	VARCHAR(60000);	-- Sentencia de Ejecucion

	-- Declaracion de Conatantes
	DECLARE Entero_Cero 	INT(11);		-- Constante Entero Cero
	DECLARE Cadena_Vacia 	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Decimal_Cero	DECIMAL;		-- Constante Decimal Cero
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE Con_SI			CHAR(1);		-- Constante SI

	DECLARE Nat_Cargo		CHAR(1);		-- Constante Naturaleza Cargo
	DECLARE Var_Cont		VARCHAR(20);	-- Constante Contigente
	DECLARE Tip_MovDesembolso 	INT(11);	-- Constante Tipo Movimiento Desembolso
	DECLARE Pri_Amortizacion 	INT(11);		-- Constante Primera Amortizacion

	-- Asignacion de Constantes
	SET Entero_Cero 	:= 0;
	SET Cadena_Vacia 	:= '';
	SET Decimal_Cero	:= 0.00;
	SET Fecha_Vacia		:= '1900-01-01';
	SET Con_SI			:= 'S';

	SET Nat_Cargo 		:= 'C';
	SET Var_Cont		:='CONTINGENTE';
	SET Tip_MovDesembolso := 1;
	SET Pri_Amortizacion	:= 1;

	SET Par_Sucursal 		:= IFNULL(Par_Sucursal,Entero_Cero);
	SET Par_ProductoCre		:= IFNULL(Par_ProductoCre, Entero_Cero);
	SET Par_Promotor		:= IFNULL(Par_Promotor,Entero_Cero);
	SET Par_MotivoCastigoID	:= IFNULL(Par_MotivoCastigoID, Entero_Cero);

	DROP TABLE IF EXISTS tmp_TMPCREDITOSCASTIGOS;
	CREATE TEMPORARY TABLE tmp_TMPCREDITOSCASTIGOS (
	CreditoActivoID     BIGINT(12),     -- ID del credito activo que se castigo
	CreditoContID       BIGINT(12),     -- ID del credito contingente que se castigo
	TipoCredito         VARCHAR(100),   -- Indica el tipo de credito: Activo, Residual, Contingente
	ClienteID           INT(12),        -- ID del cliente al que pertenece el credito castigado
	NombreCompleto      VARCHAR(250),   -- Nombre completo del cliente al que pertenece el credito castigado
	ProductoCreditoID   INT(12),        -- Nombre del producto de credito
    DescProdCred		VARCHAR(200),	-- Descripcion del producto de credito
	GrupoID             INT(11),        -- Id del Grupo
	NombreGrupo         VARCHAR(200),   -- Nombre del grupo de credito
	MontoOriginal       DECIMAL(14,2),  -- Monto original por el cual se otorgo el credito
	FechaDesembolso     DATE,           -- Fecha en que se desembolso el credito activo, en caso de ser un credito contingente, se deberá indicar la fecha en que se realizo la afectación de la garantia FEGA o FONAGA, la cual debe ser igual a la fecha de inicio del credito.
	FechaCastigo        DATE,           -- Fecha en que se realizo el castigo del credito
	MotivoCastigo       VARCHAR(200),   -- Motivo por el cual se castigo el credito
	CapitalCastigado    DECIMAL(14,2),  -- Monto de capital que se castigo
	InteresCastigado    DECIMAL(14,2),  -- Monto de interes que se castigo
	IntMoraCastigado    DECIMAL(14,2),  -- Monto de moratorios que se castigo
	ComisionesCastigado DECIMAL(14,2),  -- Monto de comisiones que se castigaron
	TotalCastigo        DECIMAL(14,2),  -- Monto total castigado
	MontoRecuperado     DECIMAL(14,2),  -- Monto que se ha recuperado del credito
	MontoRecuperar      DECIMAL(14,2),  	-- Monto pendiente de recuperar del credito.
	NombrePromotor		VARCHAR(200),	-- Nombre del promotor
	NombreSucurs		VARCHAR(200),	-- Nombre de Sucursal
	SucursalID			INT(11),		-- Sucursal ID
	PromotorActual		INT(11),		-- Promotor Actual
	HoraEmision			TIME,			-- Hora en la que se realiza el reporte
	INDEX tmp_TMPCREDITOSCASTIGOS_IDX_1(CreditoActivoID));

	-- Se inserta los Créditos Agro Activos.
	SET Var_Sentencia := '
		INSERT INTO tmp_TMPCREDITOSCASTIGOS (
				CreditoActivoID,            CreditoContID,          TipoCredito,        ClienteID,          NombreCompleto,
	            ProductoCreditoID,          DescProdCred,			GrupoID,            NombreGrupo,        MontoOriginal,
	            FechaDesembolso,            FechaCastigo,           MotivoCastigo,      CapitalCastigado,   InteresCastigado,
	            IntMoraCastigado,           ComisionesCastigado,    TotalCastigo,       MontoRecuperado,    MontoRecuperar,
				NombrePromotor,				NombreSucurs,			SucursalID,			PromotorActual,		HoraEmision)';

	SET Var_Sentencia	:=CONCAT(Var_sentencia,'SELECT Cre.CreditoID, "',Entero_Cero,'", "',Cadena_Vacia,'",  Cre.ClienteID,  Cli.NombreCompleto, Cre.ProductoCreditoID,');
	SET Var_Sentencia	:= CONCAT(Var_sentencia,' Pro.Descripcion, Cre.GrupoID,IFNULL(Gru.NombreGrupo,"")as NombreGrupo,Cre.MontoCredito, FechaMinistrado as FechaDesembolso, Cas.Fecha as FechaCastigo,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' MoCas.Descricpion as MotivoCastigo, IFNULL(Cas.CapitalCastigado,0.00) as CapitalCastigado, IFNULL(Cas.InteresCastigado,0.00) as InteresCastigado, IFNULL(Cas.IntMoraCastigado,0.00) as IntMoraCastigado,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' IFNULL(Cas.AccesorioCastigado,0.00) as Comisiones, IFNULL(Cas.TotalCastigo,0.00) as TotalCastigo, IFNULL(Cas.MonRecuperado,0.00) as MontoRecuperado, IFNULL((Cas.TotalCastigo -  Cas.MonRecuperado),0.00) as MontoRecuperar,');
	set Var_Sentencia	:=CONCAT(Var_sentencia,'  Prom.NombrePromotor, Suc.NombreSucurs, Cre.SucursalID,Cli.PromotorActual, convert(time(now()),char) as HoraEmision');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' from CREDITOS Cre');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join GRUPOSCREDITO Gru on Gru.GrupoID	= Cre.GrupoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia, ' inner join PRODUCTOSCREDITO  Pro on   Pro.ProducCreditoID = Cre.ProductoCreditoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,	' inner join CLIENTES Cli	on Cli.ClienteID = Cre.ClienteID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' inner join CRECASTIGOS Cas on Cas.CreditoID = Cre.CreditoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' inner join MOTIVOSCASTIGO MoCas on MoCas.MotivoCastigoID = Cas.MotivoCastigoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID');


	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' where Cas.Fecha between  ? and ?');

	IF(Par_Sucursal != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' and Cre.SucursalID=', convert(Par_Sucursal,char));
	END IF;

	IF(Par_ProductoCre != Entero_Cero) THEN
	       SET Var_Sentencia :=  CONCAT(Var_sentencia,' and Cre.ProductoCreditoID =',convert(Par_ProductoCre,char));
	END IF;

	IF(Par_Promotor!= Entero_Cero) THEN
	       SET Var_Sentencia := CONCAT(Var_sentencia,'  and Cli.PromotorActual=',convert(Par_Promotor,char));
	END IF;
	IF(Par_MotivoCastigoID != Entero_Cero) THEN
	       SET Var_Sentencia := CONCAT(Var_sentencia,'  and Cas.MotivoCastigoID=',convert(Par_MotivoCastigoID,char));
	END IF;
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' and Cre.EsAgropecuario = "',Con_SI,'"');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cre.SucursalID, Cli.PromotorActual,Cre.ProductoCreditoID;');



	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

	PREPARE STCRECASTIGOSREP FROM @Sentencia;
	EXECUTE STCRECASTIGOSREP  USING @FechaInicio, @FechaFin;
	DEALLOCATE PREPARE STCRECASTIGOSREP;

	UPDATE tmp_TMPCREDITOSCASTIGOS Tmp, CREDITOSMOVS Cre SET
		Tmp.FechaDesembolso = Cre.FechaOperacion
	WHERE Tmp.CreditoActivoID = Cre.CreditoID
	 AND Cre.AmortiCreID = Pri_Amortizacion
	 AND Cre.TipoMovCreID = Tip_MovDesembolso
	 AND Cre.NatMovimiento = Nat_Cargo;

	-- Se actualiza el tipo de Crédito
	UPDATE tmp_TMPCREDITOSCASTIGOS tmp INNER JOIN CREDITOS Cre ON tmp.CreditoActivoID = Cre.CreditoID SET
		tmp.TipoCredito = CASE WHEN(Cre.EstatusGarantiaFIRA = 'I')	THEN 'ACTIVO'
						WHEN (Cre.EstatusGarantiaFIRA = 'P')  THEN 'RESIDUAL'
						ELSE 'ACTIVO'
					END;

	UPDATE tmp_TMPCREDITOSCASTIGOS tmp INNER JOIN CREDITOSCONT Cre ON tmp.CreditoActivoID = Cre.CreditoID SET
		tmp.CreditoContID = Cre.CreditoID;

	-- Se inserta a la tabla los Créditos Contingentes que presentaron castigo.
	SET Var_Sentencia := '
		INSERT INTO tmp_TMPCREDITOSCASTIGOS (
				CreditoActivoID,            CreditoContID,          TipoCredito,        ClienteID,          NombreCompleto,
	            ProductoCreditoID,          DescProdCred,			GrupoID,                NombreGrupo,        MontoOriginal,
	            FechaDesembolso,            FechaCastigo,           MotivoCastigo,      CapitalCastigado,   InteresCastigado,
	            IntMoraCastigado,           ComisionesCastigado,    TotalCastigo,       MontoRecuperado,    MontoRecuperar,
				NombrePromotor,				NombreSucurs,			SucursalID,			PromotorActual,		HoraEmision)';

	SET Var_Sentencia	:=CONCAT(Var_sentencia,'SELECT Cre.CreditoID, Cre.CreditoID, "',Var_Cont,'",  Cre.ClienteID,  Cli.NombreCompleto, Cre.ProductoCreditoID,');
	SET Var_Sentencia	:= CONCAT(Var_sentencia,'Pro.Descripcion, Cre.GrupoID,IFNULL(Gru.NombreGrupo,"")as NombreGrupo,Cre.MontoCredito, FechaMinistrado as FechaDesembolso, Cas.Fecha as FechaCastigo,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' MoCas.Descricpion as MotivoCastigo, IFNULL(Cas.CapitalCastigado,0.00) as CapitalCastigado, IFNULL(Cas.InteresCastigado,0.00) as InteresCastigado, IFNULL(Cas.IntMoraCastigado,0.00) as IntMoraCastigado,');
	SET Var_Sentencia	:=CONCAT(Var_sentencia,' IFNULL(Cas.AccesorioCastigado,0.00) as Comisiones, IFNULL(Cas.TotalCastigo,0.00) as TotalCastigo, IFNULL(Cas.MonRecuperado,0.00) as MontoRecuperado, IFNULL((Cas.TotalCastigo -  Cas.MonRecuperado),0.00) as MontoRecuperar,');
	set Var_Sentencia	:=CONCAT(Var_sentencia,'  Prom.NombrePromotor, Suc.NombreSucurs, Cre.SucursalID,Cli.PromotorActual, convert(time(now()),char) as HoraEmision');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' from CREDITOSCONT Cre');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join GRUPOSCREDITO Gru on Gru.GrupoID	= Cre.GrupoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia, ' inner join PRODUCTOSCREDITO  Pro on   Pro.ProducCreditoID = Cre.ProductoCreditoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,	' inner join CLIENTES Cli	on Cli.ClienteID = Cre.ClienteID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' inner join CRECASTIGOSCONT Cas on Cas.CreditoID = Cre.CreditoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' inner join MOTIVOSCASTIGO MoCas on MoCas.MotivoCastigoID = Cas.MotivoCastigoID');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual');
	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' left join SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID');


	SET Var_Sentencia 	:=CONCAT(Var_Sentencia,' where Cas.Fecha between  ? and ?');

	IF(Par_Sucursal != Entero_Cero)then
			SET Var_Sentencia := CONCAT(Var_Sentencia,' and Cre.SucursalID=', convert(Par_Sucursal,char));
	END IF;

	IF(Par_ProductoCre != Entero_Cero)then
	       SET Var_Sentencia :=  CONCAT(Var_sentencia,' and Cre.ProductoCreditoID =',convert(Par_ProductoCre,char));
	END IF;

	IF(Par_Promotor!= Entero_Cero)then
	       SET Var_Sentencia := CONCAT(Var_sentencia,'  and Cli.PromotorActual=',convert(Par_Promotor,char));
	END IF;
	IF(Par_MotivoCastigoID != Entero_Cero)then
	       SET Var_Sentencia := CONCAT(Var_sentencia,'  and Cas.MotivoCastigoID=',convert(Par_MotivoCastigoID,char));
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cre.SucursalID, Cli.PromotorActual,Cre.ProductoCreditoID;');

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

	PREPARE STCRECASTIGOSREP FROM @Sentencia;
	EXECUTE STCRECASTIGOSREP  USING @FechaInicio, @FechaFin;
	DEALLOCATE PREPARE STCRECASTIGOSREP;

	SELECT * FROM tmp_TMPCREDITOSCASTIGOS ORDER BY CreditoActivoID ;

END	TerminaStore$$