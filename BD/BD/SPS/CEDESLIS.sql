-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESLIS`;
DELIMITER $$


CREATE PROCEDURE `CEDESLIS`(
# ==============================================
# ----------- SP PARA LISTAS DE CEDES-----------
# ==============================================
	Par_ClienteID			INT(11),		-- Numero de Cliente
	Par_NombreCliente		VARCHAR(50),	-- Nombre del Cliente
	Par_Estatus				CHAR(1),		-- Estatus de Cede
	Par_NumLis				TINYINT UNSIGNED,-- Numero de Lista

	Par_Empresa				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_EstatusISR	CHAR(1);

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
	DECLARE Lis_CEDESVigOri	INT(11);
	DECLARE Lis_GuardaValores INT(11);
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
	DECLARE DesVencimiento	VARCHAR(20);
	DECLARE DesFinMes		VARCHAR(20);
	DECLARE DesPeriodo		VARCHAR(20);
	DECLARE Var_Credi		CHAR(2);
	DECLARE Var_cliesp		CHAR(2);
	DECLARE Llaveparam 		CHAR(50);


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
	SET Lis_CEDESVigOri 	:= 12;
	SET Lis_GuardaValores	:= 13;			-- Lista de Documentos en Guarda Valores
	SET	EstatusActivo		:= 'A';			-- Estatus Activo --
	SET	Esta_Vigente		:= 'N';			-- Estatus Vigente  --
	SET Esta_Alta			:='A';			-- Estatus Alta --
	SET Esta_Cancelada		:='C';			-- Estatus Cancelada --
	SET Esta_Pagada			:='P';			-- Estatus Pagada --
	SET Esta_Vencida		:='V';			-- Estatus Vencida --
	SET Alta				:='INACTIVA';	-- Descripcion Estatus Inactivo
	SET Vigente				:='VIGENTE';	-- Descripcion Estatus Vigente
	SET Cancelada			:='CANCELADA';	-- Descripcion Estatus Cancelado
	SET Pagada				:='PAGADA';		-- Descripcion Estatus Pagado
	SET Vencida				:='VENCIDA';	-- Descripcion Estatus Vencido
	SET Registrada      	:= 'REGISTRADA';-- Descripcion Estatus Registrado
	SET Vencimiento			:= 'V';			-- Tipo de pago interes vencimiento
	SET FinMes				:= 'F';			-- Tipo de pago interes fin de mes
    SET Periodo				:= 'P';			-- Tipo de pago interes por periodo
	SET DesVencimiento		:= 'VENCIMIENTO';-- Descripcion al vencimiento
	SET DesFinMes			:= 'FIN DE MES';-- Descripion al fin de mes
    SET DesPeriodo			:= 'PERIODO';	-- Descripcion por periodo
    SET Var_Credi 			:= '24';
	SET Llaveparam      	:= 'CliProcEspecifico';


	SET Var_cliesp := (SELECT ValorParametro
					FROM PARAMGENERALES
            		WHERE LlaveParametro = Llaveparam);

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion,
			CASE Ced.Estatus 	WHEN Esta_Vencida THEN Vencida
								WHEN Esta_Vigente THEN Vigente
								WHEN Esta_Alta THEN Registrada
								WHEN Esta_Cancelada THEN Cancelada
								WHEN Esta_Pagada THEN Pagada
							END AS Estatus
			FROM 	CEDES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSCEDES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.Estatus		= Esta_Alta
			AND 	Ced.TipoCedeID	= Tc.TipoCedeID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_ResumenCte) THEN
		SET Var_EstatusISR := (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR := IFNULL(Var_EstatusISR, Cadena_Vacia);

		SELECT cede.CedeID,	tipo.Descripcion AS TipoCedeID,	cede.FechaInicio,	cede.FechaVencimiento,		FORMAT(cede.TasaISR,2) AS TasaISR,
				FORMAT(cede.TasaNeta,2) AS TasaNeta,	FORMAT(cede.InteresRecibir,2) AS InteresRecibir,
				IF(Var_Credi = Var_cliesp, cede.InteresRetener,
				FORMAT(IF(Var_EstatusISR = EstatusActivo, FNISRINFOCAL(cede.Monto, cede.Plazo, (cede.TasaISR*100)), cede.InteresRetener),2)) AS InteresRetener,
				FORMAT(cede.InteresGenerado,2) AS InteresGenerado,
				FORMAT(cede.Monto,2) AS Monto,
				CASE WHEN cede.TipoPagoInt = Vencimiento	THEN DesVencimiento
					 WHEN cede.TipoPagoInt = FinMes		 	THEN DesFinMes
                     WHEN cede.TipoPagoInt = Periodo	 	THEN DesPeriodo
					 END AS TipoPagoInt
			FROM 	CEDES cede
					INNER JOIN TIPOSCEDES tipo ON cede.TipoCedeID = tipo.TipoCedeID
			WHERE 	cede.ClienteID	= Par_ClienteID
            AND 	cede.Estatus 	= Esta_Vigente;
	END IF;


	IF(Par_NumLis = Lis_CheckList) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion, Ced.Estatus
			FROM 	CEDES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSCEDES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Ced.Estatus		= Esta_Alta
			AND 	Ced.TipoCedeID	= Tc.TipoCedeID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 15;
	END IF;

	IF(Par_NumLis = Lis_DigitaDoc) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion, Ced.Estatus
			FROM 	CEDES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSCEDES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Ced.TipoCedeID	= Tc.TipoCedeID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 15;
	END IF;

	IF(Par_NumLis = Lis_Reinversion) THEN
		SELECT 	cede.CedeID,	cte.NombreCompleto,	FORMAT(cede.Monto,2) AS Monto,	cede.FechaVencimiento,	tc.Descripcion,
				 CASE cede.Estatus WHEN Esta_Vencida THEN Vencida
						WHEN Esta_Vigente THEN Vigente
						WHEN Esta_Alta THEN Registrada
						WHEN Esta_Cancelada THEN Cancelada
						WHEN Esta_Pagada THEN Pagada END AS Estatus
			FROM 	CEDES cede
					INNER JOIN PARAMETROSSIS param ON cede.FechaVencimiento = param.FechaSistema
											AND cede.Estatus = 'N'
					INNER JOIN CLIENTES cte ON cede.ClienteID = cte.ClienteID
					INNER JOIN TIPOSCEDES tc ON cede.TipoCedeID = tc.TipoCedeID
			ORDER BY cede.CedeID,cte.NombreCompleto LIMIT 0,15;
	END IF;


	IF(Par_NumLis = Lis_Reimpresion) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion, CASE Ced.Estatus
				WHEN Esta_Vencida THEN Vencida END AS Estatus
			FROM 	CEDES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSCEDES Tc
			WHERE 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.Estatus		= Esta_Vigente
			AND 	Ced.TipoCedeID	= Tc.TipoCedeID
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaVencimiento LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_Cancela) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion
			FROM 	CEDES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSCEDES Tc
			WHERE 	Ced.Estatus IN (Esta_Alta, Esta_Vigente)
			AND 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.TipoCedeID	= Tc.TipoCedeID
			AND 	Ced.FechaInicio	= Aud_FechaActual
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.FechaInicio LIMIT 0,15;
	END IF;


	IF(Par_NumLis = Lis_VencimAnt) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion
			FROM 	CEDES Ced,
					CLIENTES Cli
					INNER JOIN TIPOSCEDES Tc
			WHERE 	Ced.Estatus 	= Esta_Vigente
			AND 	Ced.ClienteID	= Cli.ClienteID
			AND 	Cli.Estatus		= EstatusActivo
			AND 	Ced.TipoCedeID	= Tc.TipoCedeID
			AND 	Ced.FechaInicio	!= Aud_FechaActual
			AND 	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			ORDER BY Ced.CedeID LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_CEDESVigOri) THEN
		SELECT 	cede.CedeID,	cte.NombreCompleto,	FORMAT(cede.Monto,2) AS Monto,	cede.FechaVencimiento,	tc.Descripcion,
					 CASE cede.Estatus WHEN Esta_Vencida THEN Vencida
							WHEN Esta_Vigente THEN Vigente
							WHEN Esta_Alta THEN Registrada
							WHEN Esta_Cancelada THEN Cancelada
							WHEN Esta_Pagada THEN Pagada END AS Estatus
			FROM 	CEDES cede
					INNER JOIN PARAMETROSSIS param ON cede.FechaVencimiento = param.FechaSistema
												   AND cede.Estatus = 'N'
					INNER JOIN CLIENTES cte ON cede.ClienteID = cte.ClienteID
					INNER JOIN TIPOSCEDES tc ON cede.TipoCedeID = tc.TipoCedeID
					LEFT JOIN CEDESANCLAJE AS Cd ON cede.CedeID =Cd.CedeAncID
			WHERE 	Cd.CedeAncID IS NULL
			ORDER BY cede.CedeID,cte.NombreCompleto LIMIT 0,15;
	END IF;

	-- Lista de Documentos de Guarda Valores
	IF(Par_NumLis = Lis_GuardaValores) THEN
		SELECT	Ced.CedeID,Cli.NombreCompleto,FORMAT(Ced.Monto,2) AS Monto, Ced.FechaVencimiento,Tc.Descripcion,
				CASE Ced.Estatus 	WHEN Esta_Vencida THEN Vencida
									WHEN Esta_Vigente THEN Vigente
									WHEN Esta_Alta THEN Registrada
									WHEN Esta_Cancelada THEN Cancelada
									WHEN Esta_Pagada THEN Pagada
								END AS Estatus
		FROM CEDES Ced,
			 CLIENTES Cli
			 INNER JOIN TIPOSCEDES Tc
		WHERE Ced.ClienteID = Cli.ClienteID
		  AND Ced.TipoCedeID = Tc.TipoCedeID
		  AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY Ced.FechaVencimiento DESC
		LIMIT 0,15;
	END IF;


END TerminaStore$$