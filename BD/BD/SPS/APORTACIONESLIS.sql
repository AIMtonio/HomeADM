-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESLIS`;
DELIMITER $$

CREATE PROCEDURE `APORTACIONESLIS`(
# ==============================================
# ------ SP PARA LISTAS DE APORTACIONES---------
# ==============================================
	Par_ClienteID			INT(11),			-- NÚMERO DE CLIENTE.
	Par_NombreCliente		VARCHAR(50),		-- NOMBRE DEL CLIENTE.
	Par_Estatus				CHAR(1),			-- ESTATUS.
	Par_NumLis				TINYINT UNSIGNED,	-- NÚMERO DE LISTA.
	/* Parámetros de Auditoría */
	Par_Empresa				INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_EstatusISR	CHAR(1);
	DECLARE	Var_AportID		INT(11);
	DECLARE	Var_ClienteID	INT(11);
	DECLARE Var_FechaVenc	DATE;
	DECLARE	Var_CuentaAhoID	BIGINT(12);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Principal 	INT(11);
	DECLARE Lis_ResumenCte	INT(1);
	DECLARE Lis_CheckList   INT(11);
	DECLARE Lis_DigitaDoc   INT(11);
	DECLARE Lis_Reinversion	INT(11);
	DECLARE Lis_Reimpresion	INT(11);
	DECLARE Lis_Cancela     INT(11);
	DECLARE Lis_VencimAnt	INT(11);
	DECLARE Lis_APORTACIONESVigOri	INT(11);
	DECLARE	EstatusActivo	CHAR(1);
	DECLARE	Esta_Vigente	CHAR(1);
	DECLARE Esta_Alta		CHAR(1);
	DECLARE Esta_Cancelada	CHAR(1);
	DECLARE Esta_Pagada		CHAR(1);
	DECLARE Esta_Vencida	CHAR(1);
	DECLARE Alta			VARCHAR(8);
	DECLARE Vigente			VARCHAR(7);
	DECLARE Cancelada		VARCHAR(9);
	DECLARE	Pagada			VARCHAR(6);
	DECLARE Vencida			VARCHAR(7);
	DECLARE Registrada      VARCHAR(12);
	DECLARE Vencimiento		CHAR(1);
	DECLARE FinMes			CHAR(1);
	DECLARE Periodo			CHAR(1);
	DECLARE Programado		CHAR(1);
	DECLARE DesVencimiento	VARCHAR(20);
	DECLARE DesFinMes		VARCHAR(20);
	DECLARE DesPeriodo		VARCHAR(20);
	DECLARE DesProgramado	VARCHAR(20);
	DECLARE Var_Credi		CHAR(2);
	DECLARE Var_cliesp		CHAR(2);
	DECLARE Llaveparam 		CHAR(50);
	DECLARE Lis_Posteriores		TINYINT;
	DECLARE Reinver_Posterior	CHAR(1);
	DECLARE Cons_EstAut			CHAR(1);
	DECLARE Cons_DescAut		VARCHAR(20);
	DECLARE Lis_ConsolidaSaldos	INT(11);
	DECLARE Cons_SI				CHAR(1);
	DECLARE Cons_NO				CHAR(1);
	DECLARE ReinvCapital		CHAR(3);
	DECLARE ReinvCapInt			CHAR(3);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET Lis_ResumenCte		:= 3;
	SET Lis_CheckList   	:= 4;
	SET Lis_DigitaDoc   	:= 5;
	SET Lis_Reinversion		:= 6;
	SET Lis_Reimpresion		:= 7;
	SET Lis_Cancela			:= 10;
	SET Lis_VencimAnt   	:= 11;
	SET Lis_APORTACIONESVigOri 	:= 12;
	SET Lis_Posteriores		:= 13;			-- Lista las Aportaciones con estatus de reinversion "Posterior"
	SET Lis_ConsolidaSaldos	:= 20;			-- Lista aportaciones a consolidar en la renovación.
	SET	EstatusActivo		:= 'A';			-- Estatus Activo --
	SET	Esta_Vigente		:= 'N';			-- Estatus Vigente  --
	SET Esta_Alta			:='A';			-- Estatus Alta --
	SET Esta_Cancelada		:='C';			-- Estatus Cancelada --
	SET Esta_Pagada			:='P';			-- Estatus Pagada --
	SET Esta_Vencida		:='V';			-- Estatus Vencida --
	SET Alta				:='INACTIVA';		-- Descripcion Estatus --
	SET Vigente				:='VIGENTE';	-- Descripcion Estatus --
	SET Cancelada			:='CANCELADA';	-- Descripcion Estatus --
	SET Pagada				:='PAGADA';		-- Descripcion Estatus --
	SET Vencida				:='VENCIDA';	-- Desripcion Estatus --
	SET Registrada      	:= 'REGISTRADA';
	SET Vencimiento			:= 'V';			-- Tipo de pago interes vencimiento
	SET FinMes				:= 'F';			-- Tipo de pago interes fin de mes
	SET Periodo				:= 'P';			-- Tipo de pago interes por periodo
	SET Programado			:= 'E';			-- Tipo de pago interes programado
	SET DesVencimiento		:= 'VENCIMIENTO';-- Descripcion al vencimiento
	SET DesFinMes			:= 'FIN DE MES';-- Descripion al fin de mes
	SET DesPeriodo			:= 'PERIODO';	-- Descripcion por periodo
	SET DesProgramado		:= 'PROGRAMADO';-- Descripcion Programado
	SET Var_Credi 			:= '24';
	SET Llaveparam      	:= 'CliProcEspecifico';
	SET Reinver_Posterior	:= 'F';
	SET Cons_EstAut			:= 'L';			-- Estatus para aportaciones autorizadas.
	SET Cons_DescAut		:= 'AUTORIZADA';-- Descripcion para estatus autorizada
	SET Cons_SI				:= 'S';
	SET Cons_NO				:= 'N';
	SET ReinvCapital		:= 'C';
	SET ReinvCapInt			:= 'CI';

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	Ced.AportacionID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion,
			CASE Ced.Estatus 	WHEN Esta_Vencida THEN Vencida
								WHEN Esta_Vigente THEN Vigente
								WHEN Esta_Alta THEN Registrada
								WHEN Esta_Cancelada THEN Cancelada
								WHEN Esta_Pagada THEN Pagada
                                WHEN Cons_EstAut THEN Cons_DescAut
							END AS Estatus
			FROM 	APORTACIONES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSAPORTACIONES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.Estatus		IN (Esta_Alta,Cons_EstAut)
			AND 	Ced.TipoAportacionID	= Tc.TipoAportacionID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_ResumenCte) THEN
		SELECT ap.AportacionID,	tipo.Descripcion AS TipoAportacionID,	ap.FechaInicio,	ap.FechaVencimiento,		FORMAT(ap.TasaISR,2) AS TasaISR,
				FORMAT(ap.TasaNeta,2) AS TasaNeta,	FORMAT(ap.InteresRecibir,2) AS InteresRecibir,
				FORMAT(ap.InteresRetener,2) AS InteresRetener,
				FORMAT(ap.InteresGenerado,2) AS InteresGenerado,
				FORMAT(ap.Monto,2) AS Monto,
				CASE WHEN ap.TipoPagoInt = Vencimiento	THEN DesVencimiento
					 WHEN ap.TipoPagoInt = Programado	THEN DesProgramado
					 END AS TipoPagoInt
			FROM 	APORTACIONES ap
					INNER JOIN TIPOSAPORTACIONES tipo ON ap.TipoAportacionID = tipo.TipoAportacionID
			WHERE 	ap.ClienteID	= Par_ClienteID
			AND 	ap.Estatus 	= Esta_Vigente;
	END IF;


	IF(Par_NumLis = Lis_CheckList) THEN
		SELECT	Ced.AportacionID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion, Ced.Estatus
			FROM 	APORTACIONES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSAPORTACIONES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Ced.Estatus		= Esta_Alta
			AND 	Ced.TipoAportacionID	= Tc.TipoAportacionID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 15;
	END IF;

	IF(Par_NumLis = Lis_DigitaDoc) THEN
		SELECT	Ced.AportacionID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion, Ced.Estatus
			FROM 	APORTACIONES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSAPORTACIONES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Ced.TipoAportacionID	= Tc.TipoAportacionID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 15;
	END IF;

	IF(Par_NumLis = Lis_Reinversion) THEN
		SELECT 	ap.AportacionID,	cte.NombreCompleto,	FORMAT(ap.Monto,2) AS Monto,	ap.FechaVencimiento,	tc.Descripcion,
				 CASE ap.Estatus WHEN Esta_Vencida THEN Vencida
						WHEN Esta_Vigente THEN Vigente
						WHEN Esta_Alta THEN Registrada
						WHEN Esta_Cancelada THEN Cancelada
						WHEN Esta_Pagada THEN Pagada END AS Estatus
			FROM 	APORTACIONES ap
					INNER JOIN PARAMETROSSIS param ON ap.FechaVencimiento = param.FechaSistema
											AND ap.Estatus = 'N'
					INNER JOIN CLIENTES cte ON ap.ClienteID = cte.ClienteID
					INNER JOIN TIPOSAPORTACIONES tc ON ap.TipoAportacionID = tc.TipoAportacionID
			ORDER BY ap.AportacionID,cte.NombreCompleto LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_Reimpresion) THEN
		SELECT	Ced.AportacionID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion, CASE Ced.Estatus
				WHEN Esta_Vencida THEN Vencida END AS Estatus
			FROM 	APORTACIONES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSAPORTACIONES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.Estatus		= Esta_Vigente
			AND 	Ced.TipoAportacionID	= Tc.TipoAportacionID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_Cancela) THEN
		SELECT	Ced.AportacionID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion
			FROM 	APORTACIONES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSAPORTACIONES Tc
			WHERE 	Ced.Estatus IN (Esta_Alta, Esta_Vigente,Cons_EstAut)
			AND 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.TipoAportacionID	= Tc.TipoAportacionID
			AND 	Ced.FechaInicio	= Aud_FechaActual
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaInicio LIMIT 0,15;
	END IF;


	IF(Par_NumLis = Lis_VencimAnt) THEN
		SELECT	Ced.AportacionID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion
			FROM 	APORTACIONES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSAPORTACIONES Tc
			WHERE 	Ced.Estatus 	= Esta_Vigente
			AND 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.TipoAportacionID	= Tc.TipoAportacionID
			AND 	Ced.FechaInicio	!= Aud_FechaActual
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.AportacionID LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_APORTACIONESVigOri) THEN
		SELECT 	ap.AportacionID,	cte.NombreCompleto,	FORMAT(ap.Monto,2) AS Monto,	ap.FechaVencimiento,	tc.Descripcion,
					 CASE ap.Estatus WHEN Esta_Vencida THEN Vencida
							WHEN Esta_Vigente THEN Vigente
							WHEN Esta_Alta THEN Registrada
							WHEN Esta_Cancelada THEN Cancelada
							WHEN Esta_Pagada THEN Pagada END AS Estatus
			FROM 	APORTACIONES ap
					INNER JOIN PARAMETROSSIS param ON ap.FechaVencimiento = param.FechaSistema
												   AND ap.Estatus = 'N'
					INNER JOIN CLIENTES cte ON ap.ClienteID = cte.ClienteID
					INNER JOIN TIPOSAPORTACIONES tc ON ap.TipoAportacionID = tc.TipoAportacionID
					LEFT JOIN APORTANCLAJE AS Cd ON ap.AportacionID =Cd.AportacionAncID
			WHERE 	Cd.AportacionAncID IS NULL
			ORDER BY ap.AportacionID,cte.NombreCompleto LIMIT 0,15;
	END IF;

	IF (Par_NumLis = Lis_Posteriores) THEN
		SELECT
			APORT.AportacionID, 		CLI.NombreCompleto,			FORMAT(APORT.Monto,2) AS Monto, 		APORT.FechaVencimiento,
			TA.Descripcion,				CASE APORT.Estatus 	WHEN Esta_Vencida THEN VENCIDA
											WHEN Esta_Vigente THEN Vigente
											WHEN Esta_Alta THEN Registrada
											WHEN Esta_Cancelada THEN Cancelada
											WHEN Esta_Pagada THEN Pagada
										END AS Estatus
		FROM APORTACIONES APORT
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = APORT.ClienteID
		INNER JOIN TIPOSAPORTACIONES TA ON TA.TipoAportacionID = APORT.TipoAportacionID
		WHERE APORT.ClienteID		= CLI.ClienteID
			AND CLI.Estatus			= EstatusActivo
			AND APORT.Reinversion 	= Reinver_Posterior
			AND APORT.Estatus 		= Esta_Vigente
			AND CLI.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY APORT.AportacionID LIMIT 0,15;
	END IF;

	/** LISTA 20.
	 ** LISTA APORTACIONES DE UN CLIENTE
	 ** PARA LA CONSOLIDACIÓN DE SUS APORTACIONES. */
	IF(Par_NumLis = Lis_ConsolidaSaldos) THEN
		SET Var_AportID := Par_ClienteID;
		SET Var_ClienteID := (SELECT ClienteID FROM APORTACIONES WHERE AportacionID = Var_AportID);
		SET Var_FechaVenc := (SELECT FechaVencimiento FROM APORTACIONES WHERE AportacionID = Var_AportID);
		SET Var_CuentaAhoID := (SELECT CuentaAhoID FROM APORTACIONES WHERE AportacionID = Var_AportID);

		SELECT
			AP.AportacionID, 		CT.NombreCompleto,		FORMAT(AP.Monto,2) AS Monto,
			AP.FechaVencimiento,	TA.Descripcion,
			CASE AP.Estatus
				WHEN Esta_Vencida THEN VENCIDA
				WHEN Esta_Vigente THEN Vigente
				WHEN Esta_Alta THEN Registrada
				WHEN Esta_Cancelada THEN Cancelada
				WHEN Esta_Pagada THEN Pagada
			END AS Estatus
		FROM APORTACIONES AP
			INNER JOIN CLIENTES CT ON CT.ClienteID = AP.ClienteID
			INNER JOIN TIPOSAPORTACIONES TA ON TA.TipoAportacionID = AP.TipoAportacionID
		WHERE AP.ClienteID = Var_ClienteID
			AND AP.CuentaAhoID = Var_CuentaAhoID
			AND AP.FechaVencimiento = Var_FechaVenc
			AND CT.Estatus = EstatusActivo
			AND AP.Estatus = Esta_Vigente
		ORDER BY AP.AportacionID LIMIT 0,15;
	END IF;
END TerminaStore$$