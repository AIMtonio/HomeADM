-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSREP`;DELIMITER $$

CREATE PROCEDURE `RATIOSREP`(
	Par_SolicitudCreditoID	INT(11),
	Par_TipoReporte			INT,
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
-- Declaracion de Variables
DECLARE Var_Caracter		DECIMAL(14,2);
DECLARE Var_Capital			DECIMAL(14,2);
DECLARE Var_Capacidad		DECIMAL(14,2);
DECLARE Var_Condiciones		DECIMAL(14,2);
DECLARE Var_Colaterales		DECIMAL(14,2);

DECLARE Var_Residencia		DECIMAL(14,2);
DECLARE Var_Ocupacion		DECIMAL(14,2);
DECLARE Var_Mora			DECIMAL(14,2);
DECLARE Var_Afiliacion		DECIMAL(14,2);
DECLARE Var_DeudaActual		DECIMAL(14,2);

DECLARE Var_DeudaCredito	DECIMAL(14,2);
DECLARE Var_Cobertura		DECIMAL(14,2);
DECLARE Var_Gastos			DECIMAL(14,2);
DECLARE Var_GastosCredito	DECIMAL(14,2);
DECLARE Var_Estabilidad		DECIMAL(14,2);
DECLARE Var_Negocio			DECIMAL(14,2);
DECLARE Var_PuntosTotal		DECIMAL(14,2);

-- Solicitud
DECLARE Var_ClienteID				INT(11);
DECLARE Var_ProductoCreditoID		INT(11);
DECLARE Var_NombreCompleto			VARCHAR(200);
DECLARE Var_MontoSolicitado			DECIMAL(14,2);
DECLARE	Var_Plazo					VARCHAR(50)	;
DECLARE Var_TasaFija				DECIMAL(14,2);
DECLARE Var_FrecuenciaCapital		VARCHAR(50);
DECLARE Var_AporteCliente			DECIMAL(12,2);
DECLARE Var_Calificacion			VARCHAR(50);
DECLARE Var_PuntosCalificacion		DECIMAL(12,2);
DECLARE Var_ProductoCredito			VARCHAR(500);

DECLARE Var_FechaSistema			DATE;
DECLARE Var_NombreInstitucion		VARCHAR(500);

-- Declaracion de Constantes
DECLARE EstatusAutorizado			CHAR(1);
DECLARE TipoReporteCalculoRatios	INT;
DECLARE TipoReporteGarantiasAsig	INT;
DECLARE TipoReporteAvales			INT;
DECLARE TipoReporteGarantiaLiquida	INT;
DECLARE Entero_Cero					INT;

-- Asignacion de Constantes
SET EstatusAutorizado				:='U';
SET TipoReporteCalculoRatios		:=1;		-- Calculo Ratios
SET TipoReporteGarantiasAsig		:=2;		-- Tipo de Garantias Asignadas
SET TipoReporteAvales				:=3;		-- Tipo de Avales
SET TipoReporteGarantiaLiquida		:=4;		-- Tipo de Garantia
SET Entero_Cero						:=0;		-- Entero Cero


IF(Par_TipoReporte = TipoReporteCalculoRatios)THEN
		SELECT Par.FechaSistema, Ins.Nombre  INTO Var_FechaSistema, Var_NombreInstitucion
			FROM PARAMETROSSIS Par
				INNER JOIN INSTITUCIONES Ins ON Ins.InstitucionID =Par.InstitucionID
				LIMIT 1;

			SELECT  CASE WHEN Sol.ClienteID >Entero_Cero  THEN Sol.ClienteID ELSE Sol.ProspectoID END,
					CASE WHEN Sol.ClienteID >Entero_Cero THEN IFNULL(Cli.NombreCompleto, '')ELSE
							IFNULL(Pro.NombreCompleto, '') END AS ProNombreCompleto,

					Sol.MontoSolici,     	Pla.Descripcion,	Sol.TasaFija,
			CASE Sol.FrecuenciaCap
                WHEN 'S' THEN 'SEMANAL'
                WHEN 'C' THEN 'CATORCENAL'
                WHEN 'Q' THEN 'QUINCENAL'
                WHEN 'M' THEN 'MENSUAL'
                WHEN 'P' THEN 'PERIODICA'
                WHEN 'B' THEN 'BIMESTRAL'
                WHEN 'T' THEN 'TRIMESTRAL'
                WHEN 'R' THEN 'TETRAMESTRAL'
                WHEN 'E' THEN 'SEMESTRAL'
                WHEN 'A' THEN 'ANUAL'
				WHEN 'U' THEN 'PAGO UNICO'
				WHEN 'L' THEN 'LIBRE'
            END ,
					Sol.AporteCliente,
					CASE WHEN Sol.ClienteID >Entero_Cero THEN Cli.CalificaCredito  ELSE
							Pro.CalificaProspecto END AS Calificacion,
					CASE WHEN Sol.ClienteID >Entero_Cero THEN IFNULL(Cal.Calificacion, Entero_Cero)	 ELSE Entero_Cero END,
					Prod.Descripcion, Sol.ProductoCreditoID

					INTO Var_ClienteID, Var_NombreCompleto, Var_MontoSolicitado,
						Var_Plazo, Var_TasaFija, Var_FrecuenciaCapital, Var_AporteCliente, Var_Calificacion,
						Var_PuntosCalificacion,  Var_ProductoCredito, Var_ProductoCreditoID

						FROM SOLICITUDCREDITO Sol
							LEFT JOIN CLIENTES Cli        ON Sol.ClienteID = Cli.ClienteID
								LEFT JOIN PROSPECTOS Pro  ON Sol.ProspectoID = Pro.ProspectoID
								LEFT JOIN  CALIFICACIONCLI Cal ON Cal.ClienteID  =Sol.ClienteID
								LEFT JOIN 	PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID =Sol.ProductoCreditoID
								LEFT JOIN CREDITOSPLAZOS Pla ON Pla.PlazoID =Sol.PlazoID
							WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID;


							SELECT Par.FechaSistema, Ins.Nombre  INTO Var_FechaSistema, Var_NombreInstitucion
			FROM PARAMETROSSIS Par
				INNER JOIN INSTITUCIONES Ins ON Ins.InstitucionID =Par.InstitucionID
				LIMIT 1;

	CASE  WHEN Var_Calificacion ='A' THEN  SET Var_Calificacion:= 'EXCELENTE';
          WHEN Var_Calificacion ='B' THEN  SET Var_Calificacion:='BUENA';
		WHEN Var_Calificacion ='C' THEN  SET Var_Calificacion:='REGULAR';
		WHEN Var_Calificacion ='N' THEN  SET Var_Calificacion:='NO ASIGNADO'; ELSE
							SET Var_Calificacion:='NO ASIGNADO';
    END CASE;

		SET Var_Caracter	:=(SELECT Porcentaje FROM RATIOSCONFXPROD Con  WHERE  Con.ProducCreditoID = Var_ProductoCreditoID AND Con.RatiosCatalogoID =1);
		SET Var_Capital		:=(SELECT Porcentaje FROM RATIOSCONFXPROD Con  WHERE  Con.ProducCreditoID = Var_ProductoCreditoID AND Con.RatiosCatalogoID =2);
		SET Var_Capacidad	:=(SELECT Porcentaje FROM RATIOSCONFXPROD Con  WHERE  Con.ProducCreditoID = Var_ProductoCreditoID AND Con.RatiosCatalogoID =3);
		SET Var_Condiciones	:=(SELECT Porcentaje FROM RATIOSCONFXPROD  Con WHERE  Con.ProducCreditoID = Var_ProductoCreditoID AND Con.RatiosCatalogoID =4);
		SET Var_Colaterales	:=(SELECT Porcentaje FROM RATIOSCONFXPROD Con  WHERE  Con.ProducCreditoID = Var_ProductoCreditoID AND Con.RatiosCatalogoID =5);

		SET Var_Residencia	:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =6 AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Ocupacion	:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =7 AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Mora		:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =8 AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Afiliacion	:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =9 AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_DeudaActual	:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =10  AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_DeudaCredito:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =11  AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Cobertura	:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =12  AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Gastos		:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =13  AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_GastosCredito:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =14  AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Estabilidad	:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =15  AND ProducCreditoID = Var_ProductoCreditoID);
		SET Var_Negocio		:=(SELECT Porcentaje FROM RATIOSCONFXPROD WHERE RatiosCatalogoID =16  AND ProducCreditoID = Var_ProductoCreditoID);


		SELECT 	TotalResidencia,					TotalOupacion,						TotalMora, 								TotalAfiliacion,						TotalDeudaActual,
				TotalDeudaCredito,					TotalCobertura,						TotalGastos,							TotalGastosCredito,						TotalEstabilidadIng,
				TotalNegocio,						Var_Caracter AS TotalCarater,		Var_Capital AS TotalCapital,			Var_Capacidad AS TotalCapacidad,		Var_Condiciones AS TotalCondiciones,
				Var_Colaterales AS TotalColaterales,Caracter,							Capital,								CapacidadPago,							Condiciones,
				Var_Residencia AS Residencia,		Var_Ocupacion AS Ocupacion,			Var_Mora AS Mora,						Var_Afiliacion AS Afiliacion,			Var_DeudaActual AS DeudaActual,
				Var_DeudaCredito AS DeudaCredito,	Var_Cobertura AS Cobertura,			Var_Gastos AS Gastos,					Var_GastosCredito AS GastosCredito,		Var_Estabilidad AS Estabilidad,
				Var_Negocio AS Negocio,				Var_ClienteID AS ClienteID,			Var_NombreCompleto AS NombreCompleto,	Var_MontoSolicitado AS MontoSolicitado,	Var_Plazo AS Plazo,
				Var_TasaFija AS TasaFija,			Var_FrecuenciaCapital AS Frecuencia,Var_AporteCliente AS GarantiaLiquida,	Var_Calificacion AS Calificacion,		Var_PuntosCalificacion AS PuntosCalificacion,
				Var_ProductoCredito AS DescripcionProducto,	FechaCalculo, 				Var_FechaSistema AS FechaSistema,		Var_NombreInstitucion AS NombreInstitucion,
				CASE Estatus WHEN 'G' THEN 'GUARDADA'
				WHEN 'R' THEN 'RECHAZADA'
				WHEN 'P' THEN 'PROCESADA'
				WHEN 'C' THEN 'CALCULADA'
				WHEN 'E' THEN 'REGRESADA AL EJECUTIVO'
				ELSE ''
				END AS Estatus,
				CASE Estatus WHEN 'G' THEN ''
				WHEN 'R' THEN ComentarioRech
				WHEN 'P' THEN ComentarioMesaControl
				WHEN 'C' THEN ''
				WHEN 'E' THEN ComentarioEjecutivo
				ELSE ''
				END AS Comentario,
				CASE Estatus WHEN 'G' THEN ''
				WHEN 'R' THEN 'Motivo del Rechazo:'
				WHEN 'P' THEN 'Resolución del Proceso:'
				WHEN 'C' THEN ''
				WHEN 'E' THEN 'Comentarios de la Evaluación:'
				ELSE ''
				END AS LabelComentario,Var_NombreCompleto AS NombreCompleto,
                PuntosTotal,
                Niv.Descripcion AS NivelRiesgo,
                Colaterales
			FROM RATIOS Rat
				LEFT JOIN RATIOSNIVELRIESGO Niv ON Rat.NivelRiesgo = Niv.NivelRiesgoID
                WHERE
				Rat.SolicitudCreditoID = Par_SolicitudCreditoID;

END IF;

IF(Par_TipoReporte = TipoReporteGarantiasAsig)THEN
		SELECT Sol.MontoSolici	INTO	Var_MontoSolicitado
			FROM SOLICITUDCREDITO Sol
				WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID;

  SELECT  Gar.GarantiaID,	Gar.Observaciones,	Tip.Descripcion,	Gar.ValorComercial,	Asi.MontoAsignado,	Asi.Estatus,
			CONVERT(ROUND((Asi.MontoAsignado /Var_MontoSolicitado)*100,2), DECIMAL(14,2)) AS PorCubierto
            FROM ASIGNAGARANTIAS Asi
                 INNER JOIN GARANTIAS Gar ON  Asi.GarantiaID    = Gar.GarantiaID
					INNER JOIN  TIPOGARANTIAS Tip	ON Tip.TipoGarantiasID =Gar.TipoGarantiaID
            WHERE Asi.SolicitudCreditoID    = Par_SolicitudCreditoID
				AND Asi.Estatus = EstatusAutorizado;

END IF;

IF(Par_TipoReporte = TipoReporteAvales)THEN
	SELECT IF(Ap.AvalID != 0,CONCAT('AVAL-',Av.AvalID),
					IF(Ap.ProspectoID != 0,CONCAT('PROSPECTO-',Pr.ProspectoID),
                    CONCAT('CLIENTE-',Cte.ClienteID))
                    ) AS AvalID,
		IF(Ap.AvalID != 0,Av.NombreCompleto,
					IF(Ap.ProspectoID != 0,Pr.NombreCompleto,
                    Cte.NombreCompleto)
                    ) AS NombreCompleto
		FROM AVALESPORSOLICI AS Ap LEFT JOIN
			AVALES AS Av ON Ap.AvalID = Av.AvalID LEFT JOIN
            PROSPECTOS AS Pr ON Ap.ProspectoID = Pr.ProspectoID LEFT JOIN
            CLIENTES AS Cte ON Ap.ClienteID = Cte.ClienteID
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                AND Ap.Estatus = 'U';
END IF;

IF(Par_TipoReporte = TipoReporteGarantiaLiquida)THEN
	SELECT AporteCliente, FORMAT(((AporteCliente/MontoSolici)*100),2) AS Porcentaje
			FROM SOLICITUDCREDITO AS So
					WHERE SolicitudCreditoID = Par_SolicitudCreditoID ;
END IF;

END TerminaStore$$