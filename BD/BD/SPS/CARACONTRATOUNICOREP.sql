-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARACONTRATOUNICOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARACONTRATOUNICOREP`;DELIMITER $$

CREATE PROCEDURE `CARACONTRATOUNICOREP`(
/* Procedimiento para obtener los datos de la caratula de contrato unico para personas fisicas y morales de yanga */
	Par_CuentaAhoID				BIGINT(12),		-- no. de cuenta para cual se genera la caratula de contrato
	Par_SucursalID				INT(11),		-- sucursal del usuario logueado
	Par_TipoReporte     		INT,            -- Tipo o Seccion del Reporte de caratura de contrato unico.

    Par_EmpresaID       		INT,
    Aud_Usuario         		INT,
    Aud_FechaActual     		DATETIME,
    Aud_DireccionIP     		VARCHAR(15),
    Aud_ProgramaID      		VARCHAR(50),
    Aud_Sucursal        		INT(11),
    Aud_NumTransaccion  		BIGINT
	)
TerminaStore: BEGIN

# Declaracion de variables
DECLARE Var_FechaSis		DATE;
DECLARE Var_NombreGerente	VARCHAR(100);
DECLARE Var_NombreSucursal	VARCHAR(100);

DECLARE	Var_EstadoCta		CHAR(1);		-- Representa a donde se enviara el Estado de Cuenta
DECLARE Var_GAT 			DECIMAL(12,2);	-- Valor GAT de la cuenta
DECLARE Var_GATReal 		DECIMAL(12,2);	-- Valor GAT REAL de la cuenta
DECLARE Var_TasaInteres		DECIMAL(12,2);	-- Tasa de Intereses de la cuenta
DECLARE Var_NombreProducto	VARCHAR(30);	-- Nombre del Producto de Ahorro
DECLARE Var_RECA 			VARCHAR(100);	-- Num RECA del Producto de Ahorro
DECLARE Var_EsMenor 		CHAR(1);		-- Representa Si/No el cliente es Menor
DECLARE Var_NombreApoderado	VARCHAR(100);	-- Nombre del representante legal de la empresa


# Declaracion de Constantes
DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Constante_Si		CHAR(1);
DECLARE TasasInversiones	INT(1);		# para obtener las tasas de interes de las cuentas de ahorro e inversiones
DECLARE TasasGAT			INT(1);		# para obtener las tasas de ganancia anual neta GAT
DECLARE DatosGenerales		INT(1);		# obtiene los datos generales de sucursal, cliente, gerente
DECLARE BeneficiariosCta	INT(1);		# seccion para obtener los datos de los beneficiarios de la cuenta
DECLARE Var_Vigente			CHAR(1);	-- Estatus vigente del beneficiario


# Asigancion de Constantes
SET Cadena_Vacia			:= '';
SET Fecha_Vacia				:= '1900-01-01';
SET Constante_Si			:= 'S';

SET TasasInversiones		:= 1;
SET TasasGAT				:= 2;
SET DatosGenerales			:= 3;
SET BeneficiariosCta		:= 4;
SET Var_Vigente				:= 'V';

# Asiganacion de variables
	SET Var_FechaSis	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

# 1.
	IF (Par_TipoReporte = TasasInversiones)THEN

			(SELECT UPPER(Cue.Descripcion) AS Descripcion, Tas.Tasa
				FROM TIPOSCUENTAS Cue,
					 TASASAHORRO Tas
			 WHERE Cue.TipoCuentaID = Tas.TipoCuentaID
			 AND  EsBancaria = 'N'
			 GROUP BY Tas.TipoCuentaID, Tas.Tasa)

							UNION ALL

			(SELECT CONCAT(Cat.Descripcion, ' ',CONVERT(Dia.PlazoSuperior, CHAR), ' DIAS') AS Descripcion ,Tas.ConceptoInversion AS Tasa
				FROM CATINVERSION Cat,
					 DIASINVERSION Dia,
					 TASASINVERSION Tas
			 WHERE Cat.TipoInversionID = Dia.TipoInversionID
				AND Dia.DiaInversionID = Tas.DiaInversionID
				AND Dia.PlazoSuperior <= 360
			 GROUP BY Tas.DiaInversionID, Tas.ConceptoInversion);
	END IF;


# 2.
	IF (Par_TipoReporte = TasasGAT)THEN

			(SELECT UPPER(Cue.Descripcion) AS Descripcion, FUNCIONCALCTAGATAHO(Var_FechaSis,DATE_SUB(Var_FechaSis,INTERVAL 1 YEAR),Tas.Tasa)  AS GAT
				FROM TIPOSCUENTAS Cue,
					 TASASAHORRO Tas
			 WHERE Cue.TipoCuentaID = Tas.TipoCuentaID
			 AND  EsBancaria = 'N'
			 GROUP BY Tas.TipoCuentaID, Tas.Tasa)

							UNION ALL

			(SELECT CONCAT(Cat.Descripcion, ' ', CONVERT(Dia.PlazoSuperior,CHAR), ' DIAS') AS Descripcion, FUNCIONCALCTAGATINV(Fecha_Vacia,Fecha_Vacia,Tas.ConceptoInversion) AS GAT
				FROM CATINVERSION Cat,
					 DIASINVERSION Dia,
					 TASASINVERSION Tas
			 WHERE Cat.TipoInversionID = Dia.TipoInversionID
			   AND Dia.DiaInversionID = Tas.DiaInversionID
		       AND Dia.PlazoSuperior <= 360
			 GROUP BY Tas.DiaInversionID, Tas.ConceptoInversion);
	END IF;


# 3.
	IF (Par_TipoReporte = DatosGenerales)THEN

		   SELECT CONCAT(Suc.TituloGte, ' ',Usu.NombreCompleto), Suc.NombreSucurs
									FROM USUARIOS Usu,
										 SUCURSALES Suc
									WHERE Suc.SucursalID = Par_SucursalID
									 AND Suc.NombreGerente = Usu.UsuarioID
			INTO	Var_NombreGerente, Var_NombreSucursal;



			SELECT 	C.EstadoCta,				C.Gat,					C.GatReal,				C.TasaInteres,
					TC.Descripcion,		        TC.NumRegistroRECA,		CLI.EsMenorEdad
			INTO
					Var_EstadoCta,				Var_GAT,				Var_GATReal,			Var_TasaInteres,
					Var_NombreProducto,			Var_RECA,				Var_EsMenor
			FROM CUENTASAHO C
					LEFT JOIN TIPOSCUENTAS TC ON TC.TipoCuentaID = C.TipoCuentaID
					INNER JOIN CLIENTES CLI ON C.ClienteID = CLI.ClienteID
					WHERE C.CuentaAhoID = Par_CuentaAhoID;



			SELECT
					PS.NombreRepresentante
			INTO
					Var_NombreApoderado
					FROM PARAMETROSSIS PS LIMIT 1;



			SELECT LPAD(CONVERT(Cli.ClienteID, CHAR),11,0) AS ClienteID, Cli.NombreCompleto AS NombreCliente,
					Cli.RFC, Cli.RFCpm, Dir.DireccionCompleta  AS DireccionCliente,		Var_NombreGerente AS NombreGerente,
					Var_NombreSucursal AS NombreSucursal, Var_FechaSis AS FechaSistema,
					Var_EstadoCta AS EdoCta,
					Var_GAT AS GAT,
					Var_GATReal AS GATReal,
					Var_TasaInteres AS TasaInteres,
					Var_NombreProducto AS NombreProducto,
					Var_RECA AS RECA,
					Var_EsMenor AS Menor,
					Var_NombreApoderado AS NombreApoderado
			FROM CLIENTES Cli,
				 CUENTASAHO Cue,
				 DIRECCLIENTE Dir
			WHERE Cue.CuentaAhoID = Par_CuentaAhoID
			 AND Cue.ClienteID = Cli.ClienteID
			 AND Cli.ClienteID = Dir.ClienteID
			 AND Dir.Oficial = Constante_Si
			LIMIT 1;
	END IF;

	# 4.
	IF (Par_TipoReporte = BeneficiariosCta)THEN
			SELECT Cue.NombreCompleto AS NombreBeneficiario, Porcentaje
			FROM CUENTASPERSONA Cue
			WHERE Cue.EsBeneficiario = Constante_Si
			 AND Cue.EstatusRelacion = Var_Vigente
			 AND Cue.CuentaAhoID = Par_CuentaAhoID;
	END IF;

END TerminaStore$$