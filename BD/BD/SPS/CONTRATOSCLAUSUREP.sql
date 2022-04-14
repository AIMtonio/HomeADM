-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOSCLAUSUREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOSCLAUSUREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATOSCLAUSUREP`(
    Par_GrupoID         INT,
    Par_TipoReporte     INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_FacRiesgo   		DECIMAL(12,6);
DECLARE Var_TasaAnual   		DECIMAL(12,4);
DECLARE Var_TasaMens    		DECIMAL(12,4);
DECLARE Var_TasaFlat    		DECIMAL(12,4);
DECLARE Var_CreditoID   		BIGINT(12);
DECLARE Var_TotInteres  		DECIMAL(14,2);
DECLARE Var_NumAmorti   		INT;
DECLARE Var_MontoCred   		DECIMAL(14,2);
DECLARE Var_Plazo      			VARCHAR(100);
DECLARE Var_FechaVenc   		DATE;
DECLARE Var_MontoSeguro 		DECIMAL(14,2);
DECLARE Var_PorcCobert  		DECIMAL(12,4);
DECLARE Var_NomRepres   		VARCHAR(300);
DECLARE Var_Periodo     		INT;
DECLARE Var_Frecuencia  		CHAR(1);
DECLARE Var_DesFrec     		VARCHAR(100);
DECLARE Var_DiaVencimiento		VARCHAR(20);
DECLARE Var_MesVencimiento		VARCHAR(20);
DECLARE Var_AnioVencimiento		VARCHAR(20);
DECLARE Var_NumAmortizacion		INT;
DECLARE Var_NombreGrupo			VARCHAR(50);
DECLARE Var_DirecOficiaPredte  	VARCHAR(500);
DECLARE Var_NombreIntegrante	VARCHAR(100);
DECLARE Var_DirecIntegrante		VARCHAR(100);
DECLARE Var_NumTransaccion		BIGINT(20);
DECLARE Var_ContIntegrantes    	BIGINT(20);
DECLARE Var_ConsecIntegra 		INT;
DECLARE Var_NumRECA    			VARCHAR(200);
DECLARE Var_FrecSeguro  		VARCHAR(100);


-- Declaracion de Constantes
DECLARE Cadena_Vacia       	 	CHAR(1);
DECLARE Entero_Cero        	 	INT;
DECLARE Fecha_Vacia        	 	DATE;
DECLARE Est_Activo         	 	CHAR(1);
DECLARE Int_Presiden       	 	INT;
DECLARE Tipo_EncClausulado   	INT;
DECLARE Tipo_Integrantes		INT;
DECLARE DirecOficial			CHAR(1);
DECLARE LimiteIntegrantes		INT ;
DECLARE NumIntegrantes		 	INT;
-- Asignacion de Constantes
SET Cadena_Vacia			:= '';              -- String Vacio
SET Fecha_Vacia				:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero				:= 0;               -- Entero en Cero
SET Est_Activo				:= 'A';             -- Estatus del Integrante: Activo
SET Int_Presiden			:= 1;               -- Tipo de Integrante: Presidente
SET Tipo_EncClausulado		:= 1;				 -- Encabezado para el Rep. Contratos Clausulado
SET Tipo_Integrantes 		:= 2;				 -- Detalle de Contrato: Integrantes del Credito Grupal
SET DirecOficial			:= 'S';				  -- Direccion Oficlial del cliente
SET LimiteIntegrantes		:= 12;			 	 -- limite de integrantes en la tabla temportal


-- Tipo de Reporte Anexi
IF (Par_TipoReporte = Tipo_EncClausulado) THEN

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;

    SELECT 	Sol.TasaFija,        Sol.CreditoID, 	Sol.NumAmortizacion, Sol.MontoAutorizado,
				Sol.PeriodicidadCap, Sol.FrecuenciaCap
		INTO
				Var_TasaAnual,       Var_CreditoID, 	Var_NumAmorti,       Var_MontoCred,
				Var_Periodo,         Var_Frecuencia
        FROM 	INTEGRAGRUPOSCRE Ing,
				SOLICITUDCREDITO Sol
        WHERE 	Ing.GrupoID   		 	 = Par_GrupoID
          AND 	Ing.Cargo    			 = Int_Presiden
          AND 	Ing.Estatus  			 = Est_Activo
          AND 	Ing.SolicitudCreditoID	 = Sol.SolicitudCreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);

    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);

    SELECT SUM(Amo.Interes) INTO Var_TotInteres
	FROM 	AMORTICREDITO Amo
	WHERE 	Amo.CreditoID = Var_CreditoID;

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
    SET Var_TasaFlat    := ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
                                Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);



    SELECT   	Cre.FechaVencimien,Pro.FactorRiesgoSeguro,
				CONCAT(PrimerNombre,
                    (CASE WHEN IFNULL(SegundoNombre, '') != '' THEN CONCAT(' ', SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
					(CASE WHEN IFNULL(TercerNombre, '') != '' THEN  CONCAT(' ', TercerNombre)
                         ELSE Cadena_Vacia
					 END), ' ',
                  ApellidoPaterno, ' ', ApellidoMaterno), 		NumAmortizacion ,	  Pro.RegistroRECA
		INTO
				Var_FechaVenc,	Var_FacRiesgo,	 Var_NomRepres,	Var_NumAmortizacion,  Var_NumRECA
        FROM 	CREDITOS Cre,
				PRODUCTOSCREDITO Pro,
				CLIENTES Cli
        WHERE 	Cre.CreditoID 			= Var_CreditoID
          AND 	Cre.ProductoCreditoID  	= Pro.ProducCreditoID
          AND 	Cre.ClienteID 			= Cli.ClienteID;

	SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);
    SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 4);


	SELECT Gpo.NombreGrupo,  	Dir.DireccionCompleta 	 INTO
			Var_NombreGrupo, 	Var_DirecOficiaPredte
	FROM 	GRUPOSCREDITO Gpo
	INNER JOIN INTEGRAGRUPOSCRE Inte 	ON 	Inte.GrupoID 	=  Gpo.GrupoID
										AND	Inte.Cargo		=  Int_Presiden
	INNER JOIN CLIENTES Cli 			ON 	Cli.ClienteID 	=  Inte.ClienteID
	INNER JOIN DIRECCLIENTE Dir 		ON  Dir.ClienteID	=  Inte.ClienteID
										AND	Dir.Oficial		=  DirecOficial
	WHERE Gpo.GrupoID	=	Par_GrupoID;




    SELECT UPPER( CASE
                WHEN Var_Frecuencia ='S' THEN 'semanal'
                WHEN Var_Frecuencia ='C' THEN 'catorcenal'
                WHEN Var_Frecuencia ='Q' THEN 'quincenal'
                WHEN Var_Frecuencia ='M' THEN 'mensual'
                WHEN Var_Frecuencia ='P' THEN 'periodica'
                WHEN Var_Frecuencia ='B' THEN 'bimestral'
                WHEN Var_Frecuencia ='T' THEN 'trimestral'
                WHEN Var_Frecuencia ='R' THEN 'tetramestral'
                WHEN Var_Frecuencia ='E' THEN 'semestral'
                WHEN Var_Frecuencia ='A' THEN 'anual'
            END )INTO Var_DesFrec;

		SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

    SELECT  UPPER(CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
            CASE
                WHEN Var_Frecuencia ='S' THEN 'semanas'
                WHEN Var_Frecuencia ='C' THEN 'catorcenas'
                WHEN Var_Frecuencia ='Q' THEN 'quincenas'
                WHEN Var_Frecuencia ='M' THEN 'meses'
                WHEN Var_Frecuencia ='P' THEN 'periodos'
                WHEN Var_Frecuencia ='B' THEN 'bimestres'
                WHEN Var_Frecuencia ='T' THEN 'trimestres'
                WHEN Var_Frecuencia ='R' THEN 'tetramestres'
                WHEN Var_Frecuencia ='E' THEN 'semestres'
                WHEN Var_Frecuencia ='A' THEN 'años'

            END ) )INTO Var_Plazo;

	SELECT DAY(Var_FechaVenc) , 	YEAR(Var_FechaVenc) , CASE
				WHEN MONTH(Var_FechaVenc) = 1  THEN 'ENERO'
				WHEN MONTH(Var_FechaVenc) = 2  THEN 'FEBRERO'
				WHEN MONTH(Var_FechaVenc) = 3  THEN 'MARZO'
				WHEN MONTH(Var_FechaVenc) = 4  THEN 'ABRIL'
				WHEN MONTH(Var_FechaVenc) = 5  THEN 'MAYO'
				WHEN MONTH(Var_FechaVenc) = 6  THEN 'JUNIO'
				WHEN MONTH(Var_FechaVenc) = 7  THEN 'JULIO'
				WHEN MONTH(Var_FechaVenc) = 8  THEN 'AGOSTO'
				WHEN MONTH(Var_FechaVenc) = 9  THEN 'SEPTIEMBRE'
				WHEN MONTH(Var_FechaVenc) = 10 THEN 'OCTUBRE'
				WHEN MONTH(Var_FechaVenc) = 11 THEN 'NOVIEMBRE'
				WHEN MONTH(Var_FechaVenc) = 12 THEN 'DICIEMBRE' END

	INTO 	Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;


		SELECT  CASE

                WHEN Var_Frecuencia ='S' THEN 'semana'
                WHEN Var_Frecuencia ='C' THEN 'catorcena'
                WHEN Var_Frecuencia ='Q' THEN 'quincena'
                WHEN Var_Frecuencia ='M' THEN 'mes'
                WHEN Var_Frecuencia ='P' THEN 'periodo'
                WHEN Var_Frecuencia ='B' THEN 'bimestre'
                WHEN Var_Frecuencia ='T' THEN 'trimestre'
                WHEN Var_Frecuencia ='R' THEN 'tetramestre'
                WHEN Var_Frecuencia ='E' THEN 'semestre'
                WHEN Var_Frecuencia ='A' THEN 'año'

            END  INTO Var_FrecSeguro;


    SELECT Var_Plazo,     	 	Var_DesFrec,    		Var_TasaAnual,  		Var_TasaMens,
            Var_TasaFlat,   	Var_MontoSeguro,    	Var_PorcCobert, 		Var_NomRepres,
			Var_NombreGrupo, 	Var_DirecOficiaPredte, 	Var_DiaVencimiento, 	Var_AnioVencimiento,
			Var_MesVencimiento,	Var_NumAmortizacion,	Var_NumRECA,			Var_FrecSeguro;


END IF;

IF (Par_TipoReporte = Tipo_Integrantes) THEN
	-- Obtenemos el numero de transaccion del grupo
	SELECT NumTransaccion 		INTO
			Var_NumTransaccion
	FROM 	GRUPOSCREDITO
	WHERE 	GrupoID		=	Par_GrupoID;

	-- Limpia la tabla con rregistros anteriores.
	DELETE FROM TMPINTEGRACONTRATOS
	WHERE 	NumTransaccion = Var_NumTransaccion;

    -- Se insertan los primeros Integrantes
    -- insert into TMPINTEGRACONTRATOS
	DROP TABLE IF EXISTS tmp_TMPINTEGRACONTRATOS;

	CREATE TEMPORARY TABLE tmp_TMPINTEGRACONTRATOS ( NumeroID			INT AUTO_INCREMENT,
									  `NombreIntegrante` VARCHAR(100) DEFAULT NULL,
									  `DireccionIntegrante` VARCHAR(500) DEFAULT NULL,
									  `Comision` DECIMAL(14,2) DEFAULT NULL,
									  `NumTransaccion` BIGINT(20) DEFAULT NULL,
									  `Consecutivo` INT(11) DEFAULT NULL,
									  PRIMARY KEY (NumeroID)
									);

		INSERT INTO tmp_TMPINTEGRACONTRATOS (NombreIntegrante, DireccionIntegrante, Comision, NumTransaccion, Consecutivo)
        SELECT  CONCAT(Cli.PrimerNombre,
                    (CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ', Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)	 AS NombreIntegrante,
                Dir.DireccionCompleta 	 AS DireccionIntegrante,
				CASE 	WHEN IFNULL(Cre.MontoSeguroVida,Entero_Cero) = Entero_Cero
						THEN 0.0
						ELSE Cre.MontoSeguroVida
				END  	AS Comision, Var_NumTransaccion, Entero_Cero
        FROM  INTEGRAGRUPOSCRE Inte
        INNER JOIN CREDITOS Cre 		ON Inte.SolicitudCreditoID	= Cre.SolicitudCreditoID
        INNER JOIN CLIENTES Cli 		ON Cli.ClienteID 			= Inte.ClienteID
        INNER JOIN DIRECCLIENTE Dir 	ON Dir.ClienteID			= Inte.ClienteID
									   AND Dir.Oficial				= DirecOficial
        WHERE 	Inte.GrupoID	= Par_GrupoID
          AND 	Inte.Estatus   	= Est_Activo;



	-- Se obtiene el numero de Integrantes del Grupo
	SELECT COUNT(*) INTO Var_ContIntegrantes
	FROM tmp_TMPINTEGRACONTRATOS WHERE
	NumTransaccion = Var_NumTransaccion;

  -- Inicia el ciclo para actualizar el numero Consecutivo
  -- de los integrantes insertados para ordenarlos
  SET Var_ConsecIntegra:= 1;



     UPDATE tmp_TMPINTEGRACONTRATOS
	SET  Consecutivo 		= NumeroID
		,NombreIntegrante = CONCAT( CAST(NumeroID AS CHAR),".", NombreIntegrante);

	 SET Var_ConsecIntegra = (SELECT COUNT(*)+1 FROM tmp_TMPINTEGRACONTRATOS);



INSERT INTO TMPINTEGRACONTRATOS
SELECT NombreIntegrante, DireccionIntegrante, Comision, NumTransaccion, Consecutivo
FROM tmp_TMPINTEGRACONTRATOS;

DROP TABLE tmp_TMPINTEGRACONTRATOS;

	-- Inicia ciclo para llenar los espacios vacios
  WHILE Var_ContIntegrantes < LimiteIntegrantes DO


		INSERT INTO TMPINTEGRACONTRATOS VALUES (
			'-------------Valor Nulo -------------',
			'-------------Valor Nulo -------------',
			0.0,
			Var_NumTransaccion,
			Var_ConsecIntegra
		);

		SET Var_ContIntegrantes	:= Var_ContIntegrantes 	+1;
		SET Var_ConsecIntegra 	:= Var_ConsecIntegra 	+1 ;

  END WHILE;

	-- Se Obtiene los Integrantes del grupo
	SELECT	Consecutivo, NombreIntegrante, DireccionIntegrante,Comision
	FROM	TMPINTEGRACONTRATOS
	WHERE	NumTransaccion = Var_NumTransaccion
	ORDER BY Consecutivo ASC;



END IF;

END TerminaStore$$