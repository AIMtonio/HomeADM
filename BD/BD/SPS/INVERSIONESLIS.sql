-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONESLIS`;
DELIMITER $$


CREATE PROCEDURE `INVERSIONESLIS`(
# ========================================================================================================================
# --------------------- SP PARA LISTAR LAS INVERSIONES DE UN CLIENTE ------------------------------
# ========================================================================================================================
	Par_ClienteID		INT(11),		-- Numero de Cliente
	Par_NombreCliente	VARCHAR(50),	-- Nombre del Cliente
	Par_Estatus			CHAR(1),		-- Estatus de la inversion
    Par_Etiqueta		VARCHAR(100),	-- Descripcion de la inversion
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

    -- Parametros de Auditoria
	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT	)

TerminaStore: BEGIN

DECLARE Var_EstatusISR			CHAR(1);
DECLARE Var_Contador			INT(11);
DECLARE Var_Limite				INT(11);
DECLARE Var_InversionID			INT(11);
DECLARE Var_FechaVen			DATE;
DECLARE Var_InteresGen			DECIMAL(12,2);
DECLARE Var_InteresRet			DECIMAL(12,2);
DECLARE Var_FechaSis			DATE;

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Principal 	INT;
DECLARE	Lis_ResumenCte 	INT;
DECLARE	Lis_Cancela		INT;
DECLARE Lis_Reinversion INT;
DECLARE Lis_VencimientoAnt INT;
DECLARE Lis_InverVigente	INT(11);
DECLARE	EstatusActivo	CHAR(1);
DECLARE	Status_Vigente	CHAR(1);
DECLARE Var_Credi		CHAR(2);
DECLARE Var_cliesp		CHAR(2);
DECLARE Llaveparam 		CHAR(50);
DECLARE Factor_Porcen	DECIMAL(12,2);
DECLARE Var_SalMinAn	DECIMAL(14,4);
DECLARE Var_SalMinDF	DECIMAL(14,4);
DECLARE Fre_DiasAnio	DECIMAL(10,2);
DECLARE Var_DiasInversion	DECIMAL(12,4);
DECLARE Lis_ExtravioDocs	INT;
DECLARE Lis_GuardaValores 	INT(11);
DECLARE Lis_InverVencidos	INT(11);
DECLARE Status_Vencido		CHAR(1);
DECLARE Decimal_Cero		DECIMAL(12,2);

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 1;
SET	Lis_ResumenCte	:= 2;
SET	Lis_Cancela		:= 3;
SET Lis_Reinversion := 5;
SET Lis_VencimientoAnt := 6;
SET Lis_InverVigente	:= 7;
SET Lis_ExtravioDocs := 8;
SET	EstatusActivo	:= 'A';
SET	Status_Vigente	:= 'N';
SET Var_Credi 		:= '24';
SET Llaveparam      := 'CliProcEspecifico';
SET Factor_Porcen	:= 100.00;
SET Lis_GuardaValores	:= 9;			-- Lista de Documentos en Guarda Valores
SET Lis_InverVencidos := 10;			-- Lista para consulta de inversiones vencidos de clientes
SET Status_Vencido	:= 'P';				-- Estatus Vencido
SET Decimal_Cero	:= 0.00;

SET Var_cliesp := (SELECT ValorParametro
					FROM PARAMGENERALES
					WHERE LlaveParametro = Llaveparam);

SELECT DiasInversion
INTO  Var_DiasInversion
FROM PARAMETROSSIS;


IF(Par_NumLis = Lis_Principal) THEN
	SELECT	Inv.InversionID,Cli.NombreCompleto,format(Inv.Monto,2), Inv.FechaVencimiento,Cat.Descripcion
		FROM INVERSIONES Inv,
			CLIENTES Cli
			INNER JOIN CATINVERSION Cat
		WHERE Inv.ClienteID		= Cli.ClienteID
		  AND Inv.Estatus		= Par_Estatus
		  AND Cat.TipoInversionID=Inv.TipoInversionID
		  AND Inv.FechaInicio= Aud_FechaActual
		  AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY FechaVencimiento LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_ResumenCte) THEN
		SET Var_EstatusISR := (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR := IFNULL(Var_EstatusISR, Cadena_Vacia);

       SET Fre_DiasAnio    :=  (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='ValorUMABase');
	   SET Var_SalMinDF    :=  (SELECT param.SalMinDF FROM PARAMETROSSIS param);
       SET Var_SalMinAn    :=  Var_SalMinDF  * 5  * Fre_DiasAnio;

		SELECT	I.InversionID, 	C.Descripcion AS TipoInversionID,	I.Etiqueta,
				I.FechaInicio, 	I.FechaVencimiento, 			FORMAT(I.TasaISR,2) AS TasaISR,
				FORMAT(I.TasaNeta,2 ) AS TasaNeta,				FORMAT(I.InteresRecibir,2) AS InteresRecibir,
			IF(Var_Credi = Var_cliesp,I.InteresRetener,
								 FORMAT(IF(Var_EstatusISR = EstatusActivo, FNISRINFOCAL(I.Monto, I.Plazo, (I.TasaISR*100)), I.InteresRetener),2)) AS InteresRetener,
				FORMAT(I.InteresGenerado,2) AS InteresGenerado,
				FORMAT(I.Monto,2) AS Monto
		FROM INVERSIONES I,
			CATINVERSION C
		WHERE I.ClienteID			= Par_ClienteID
		  AND I.TipoInversionID	= C.TipoInversionID
		  AND I.Estatus 			= Status_Vigente;
END IF;

IF(Par_NumLis = Lis_Cancela) THEN
	SELECT	Inv.InversionID,Cli.NombreCompleto, format(Inv.Monto,2),	Inv.FechaVencimiento, Cat.Descripcion
		FROM INVERSIONES Inv
			INNER JOIN CLIENTES Cli ON Inv.ClienteID		= Cli.ClienteID
			INNER JOIN CATINVERSION Cat
		WHERE Inv.Estatus		IN (EstatusActivo, Status_Vigente)
		  AND Cat.TipoInversionID=Inv.TipoInversionID
		  AND Inv.FechaInicio= Aud_FechaActual
		  AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY FechaVencimiento LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_Reinversion) THEN
	SELECT	Inv.InversionID,Cli.NombreCompleto, format(Inv.Monto,2),	Inv.FechaVencimiento, Cat.Descripcion
		FROM INVERSIONES Inv
			INNER JOIN CLIENTES Cli ON Inv.ClienteID		= Cli.ClienteID
			INNER JOIN CATINVERSION Cat
		WHERE Inv.Estatus = Status_Vigente
		  AND Cat.TipoInversionID= Inv.TipoInversionID
	 	  AND Inv.FechaVencimiento= Aud_FechaActual
		  AND Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY FechaVencimiento LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_VencimientoAnt) THEN
	SELECT	Inv.InversionID,Cli.NombreCompleto,format(Inv.Monto,2), Inv.FechaVencimiento,Cat.Descripcion
		FROM INVERSIONES Inv,
			CLIENTES Cli
			INNER JOIN CATINVERSION Cat
		WHERE Inv.ClienteID		= Cli.ClienteID
		  AND Inv.Estatus		= Par_Estatus
		  AND Cat.TipoInversionID=Inv.TipoInversionID
		  AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY FechaVencimiento LIMIT 0,15;
END IF;


IF(Par_NumLis = Lis_InverVigente) THEN
	SELECT	Inv.InversionID,Inv.Etiqueta,format(Inv.Monto,2) AS Monto, Inv.FechaVencimiento,Cat.Descripcion
		FROM INVERSIONES Inv,
			CLIENTES Cli
			INNER JOIN CATINVERSION Cat
		WHERE Inv.ClienteID		= Cli.ClienteID
        AND Inv.ClienteID = Par_ClienteID
		  AND Cat.TipoInversionID=Inv.TipoInversionID
		  AND	Inv.Etiqueta	LIKE CONCAT("%", Par_Etiqueta, "%")
           AND Inv.Estatus 			= Status_Vigente
		ORDER BY FechaVencimiento LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_ExtravioDocs)THEN
	SELECT	Inv.InversionID,Cli.NombreCompleto,format(Inv.Monto,2), Inv.FechaVencimiento,Cat.Descripcion
		FROM INVERSIONES Inv,
			CLIENTES Cli
			INNER JOIN CATINVERSION Cat
		WHERE Inv.ClienteID		= Cli.ClienteID
		  AND Inv.Estatus		IN (Status_Vigente,EstatusActivo)
		  AND Cat.TipoInversionID=Inv.TipoInversionID
		  AND	Cli.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY FechaVencimiento LIMIT 0,15;
END IF;


	-- Lista de Documentos de Guarda Valores
	IF(Par_NumLis = Lis_GuardaValores) THEN
		SELECT	Inv.InversionID, Cli.NombreCompleto, FORMAT(Inv.Monto,2), Inv.FechaVencimiento, Cat.Descripcion
		FROM INVERSIONES Inv,
			 CLIENTES Cli
		INNER JOIN CATINVERSION Cat
		WHERE Inv.ClienteID = Cli.ClienteID
		  AND Cat.TipoInversionID = Inv.TipoInversionID
		  AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreCliente, "%")
		ORDER BY FechaVencimiento DESC
		LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_InverVencidos) THEN
		DROP TABLE IF EXISTS `TMPINVERVENCIDOS`;
		CREATE TEMPORARY TABLE `TMPINVERVENCIDOS`(
			ConsecutivoID INT(11) COMMENT 'Valor consecutivo por registro',
			InversionID INT(11) COMMENT 'identificador de la tabla',
			TipoInversionID VARCHAR(45) COMMENT 'Tipo de inversion realizada',
			Etiqueta VARCHAR(100) COMMENT 'Etiqueta o Referencia del Motivo de Apertura de la Inversion',
			FechaInicio DATE COMMENT 'Fecha de inicio de la inversion',
			FechaVencimiento DATE COMMENT 'Feche en que vencio la inversion',
			TasaISR	DECIMAL(12,2) COMMENT 'Tasa del ISR Generado',
			TasaNeta DECIMAL(12,2) COMMENT 'Tasa Neta Generado',
			Monto DECIMAL(12,2) COMMENT 'Monto de la inversion',
			InteresGenerado DECIMAL(12,2) COMMENT ' Interes Generado',
			InteresRetener DECIMAL(12,2) COMMENT 'Intere retenido',
			InteresRecibir DECIMAL(12,2) COMMENT 'Interes recibido',
			PRIMARY KEY(ConsecutivoID),
            INDEX index_TMPINVERVENCIDOS_1(InversionID),
            INDEX index_TMPINVERVENCIDOS_2(ConsecutivoID)
		);
		SET @Cons := 0;
		INSERT INTO TMPINVERVENCIDOS (SELECT @Cons := @Cons+1,I.InversionID, 	C.Descripcion ,	I.Etiqueta,
				I.FechaInicio, 	I.FechaVencimiento, 			I.TasaISR ,
				I.TasaNeta,				I.Monto,
				Decimal_Cero,	Decimal_Cero,	Decimal_Cero

		FROM INVERSIONES I,
			CATINVERSION C
		WHERE I.ClienteID			= Par_ClienteID
		  AND I.TipoInversionID	= C.TipoInversionID
		  AND I.Estatus 			= Status_Vencido);

		SELECT MAX(ConsecutivoID) INTO Var_Limite FROM TMPINVERVENCIDOS;

		SET Var_Limite := IFNULL(Var_Limite,Entero_Cero);
		SET Var_Contador := 1;
		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

		IniciaCiclo:WHILE Var_Contador <= Var_Limite DO
			SELECT InversionID,FechaVencimiento
			INTO Var_InversionID , Var_FechaVen
			FROM TMPINVERVENCIDOS
			WHERE ConsecutivoID = Var_Contador;

			IF SUBSTR(Var_FechaVen,1,7) = SUBSTR(Var_FechaSis,1,7) THEN

				SELECT CantidadMov INTO Var_InteresGen
				FROM CUENTASAHOMOV
				WHERE TipoMovAhoID = 62
				AND ReferenciaMov = Var_InversionID;

				SELECT CantidadMov INTO Var_InteresRet
				FROM CUENTASAHOMOV
				WHERE TipoMovAhoID = 64
				AND ReferenciaMov = Var_InversionID;

			ELSE

				SELECT CantidadMov INTO Var_InteresGen
				FROM `HIS-CUENAHOMOV`
				WHERE TipoMovAhoID = 62
				AND ReferenciaMov = Var_InversionID;

				SELECT CantidadMov INTO Var_InteresRet
				FROM `HIS-CUENAHOMOV`
				WHERE TipoMovAhoID = 64
				AND ReferenciaMov = Var_InversionID;

			END IF;

			UPDATE TMPINVERVENCIDOS SET
				InteresGenerado	=	IFNULL(Var_InteresGen,Decimal_Cero),
				InteresRetener	=	IFNULL(Var_InteresRet,Decimal_Cero),
				InteresRecibir	=	IFNULL((Var_InteresGen - Var_InteresRet),Decimal_Cero)
			WHERE ConsecutivoID	=	Var_Contador;

			SET Var_Contador := Var_Contador +1;
		END WHILE IniciaCiclo;

		SELECT InversionID,		TipoInversionID,	Etiqueta,	FechaInicio,		FechaVencimiento,
				FORMAT(TasaISR,2) TasaISR,		FORMAT(TasaNeta,2) TasaNeta,		FORMAT(InteresRecibir,2) InteresRecibir,
                FORMAT(InteresRetener,2) InteresRetener,
				FORMAT(InteresGenerado,2) InteresGenerado, FORMAT(Monto,2) Monto
		FROM TMPINVERVENCIDOS;
	END IF;
END TerminaStore$$