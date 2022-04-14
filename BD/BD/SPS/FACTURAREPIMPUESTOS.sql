-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAREPIMPUESTOS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAREPIMPUESTOS`;
DELIMITER $$

CREATE PROCEDURE `FACTURAREPIMPUESTOS`(
	-- Proceso que calcula los Importes de los Impuestos
	Par_FechaInicio			DATE,			-- Fecha de Inicio
	Par_FechaFin 			DATE,			-- Fecha de Fin
	Par_OrigenDatos			VARCHAR(50),	-- Origen de Datos

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATE,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria

)
BEGIN

	-- Declaracion de variables
	DECLARE Var_Variables		VARCHAR(500);
	DECLARE Var_QueryTable 		VARCHAR(500);
	DECLARE	Var_InsertaEnTabla	TEXT(90000);
	DECLARE	Var_ColumnasTabla	TEXT(90000);
	DECLARE Var_NombreTabla     VARCHAR(40);
	DECLARE Var_NombreColumna   VARCHAR(40);
	DECLARE Var_CreateTable     VARCHAR(9000);
	DECLARE Var_InsertTable     TEXT(90000);
	DECLARE Var_InsertValores   TEXT(90000);
	DECLARE Var_CreateTabImp    VARCHAR(50000);
	DECLARE Var_CreateTabIndice	VARCHAR(1000);
	DECLARE Var_InsertTabImp    VARCHAR(50000);
	DECLARE Var_DropTable       VARCHAR(5000);
	DECLARE Var_CantCaracteres  INT(11);
	DECLARE Var_NumColumna		INT(11);
	DECLARE Var_NumMaxColumna	INT(11);
	DECLARE Var_Contador		INT(11);
	DECLARE Var_ContadorDatos	INT(11);
	DECLARE Var_NumeroDatos		INT(11);
	DECLARE Var_ImpuestoID		INT(11);
	DECLARE Var_DescripCorta	VARCHAR(10);
	DECLARE Var_NoFactura		VARCHAR(20);
	DECLARE Var_ProveedorID		INT(11);
	DECLARE Var_NomCol 			VARCHAR(10);
	DECLARE Var_MontoImpuesto   DECIMAL(14,2);
	DECLARE Var_Columnas		VARCHAR(5000);

	-- Cursor para obtener la descripcion de los impuestos
	DECLARE cursor_TablaImpuestos CURSOR FOR
		SELECT DISTINCT(I.DescripCorta)
		FROM PROVEEDORES P
		INNER JOIN TIPOPROVEEDORES T ON P.TipoProveedor = T.TipoProveedorID
		INNER JOIN TIPOPROVEIMPUES TI ON T.TipoProveedorID = TI.TipoProveedorID
		INNER JOIN IMPUESTOS I ON TI.ImpuestoID = I.ImpuestoID;

	-- Cursor para obtener la informacion de las Facturas
	DECLARE cursor_Datos CURSOR FOR
		SELECT 	CONVERT(LPAD(Fac.ProveedorID, 11,"0"), CHAR) AS  ProveedorID, Fac.NoFactura,
				IFNULL(D.ImporteImpuesto,0.00), D.ImpuestoID,I.DescripCorta
		FROM FACTURAPROV Fac
		INNER JOIN DETALLEIMPFACT D ON Fac.ProveedorID = D.ProveedorID AND Fac.NoFactura = D.NoFactura
		INNER JOIN IMPUESTOS I ON I.ImpuestoID = D.ImpuestoID
		WHERE Fac.FechaFactura >= Par_FechaInicio AND Fac.FechaFactura <= Par_FechaFin
		ORDER BY Fac.ProveedorID, Fac.FechaFactura, Fac.Estatus ASC;

	-- Asignacion de contantes
	SET Var_ContadorDatos	:= 1;	-- Contador de registros
	SET Var_NumeroDatos		:= 0;	-- Numero de registros
	SET Var_Contador		:= 1;	-- Contador
	SET @Var_ContColumna 	:= 0;	-- Contador de columnas
	SET Var_NumeroDatos 	:= (SELECT 	COUNT(Fac.NoFactura)
									FROM FACTURAPROV Fac
									INNER JOIN DETALLEIMPFACT D ON Fac.ProveedorID = D.ProveedorID AND Fac.NoFactura = D.NoFactura
									INNER JOIN IMPUESTOS I ON I.ImpuestoID = D.ImpuestoID
									WHERE Fac.FechaFactura >= Par_FechaInicio  AND Fac.FechaFactura <= Par_FechaFin);

	DROP TABLE IF EXISTS TMPIMPUESTOS;

	-- Asignacion de valores a variables para crear la tabla TMPIMPUESTOS
	SET Var_NombreTabla     := 'TMPIMPUESTOS';
	SET Var_CreateTable     := CONCAT( " CREATE  TABLE ", Var_NombreTabla," (");
	SET Var_InsertTable     := CONCAT(" INSERT INTO ", Var_NombreTabla ," ");
	SET Var_InsertValores   := ' VALUES ';

	-- Cursor para obtener la descripcion de los impuestos
	OPEN  cursor_TablaImpuestos;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH cursor_TablaImpuestos  INTO     Var_NomCol;
					SET Var_NomCol := REPLACE(REPLACE(REPLACE(TRIM(Var_NomCol),' ','_'),'-','_'),'.','');
					SET Var_NomCol := REPLACE(TRIM(Var_NomCol),'%','');
					SET Var_CantCaracteres  := CHAR_LENGTH(Var_CreateTable);
					SET Var_CreateTable := CONCAT(Var_CreateTable, CASE WHEN Var_CantCaracteres > 39 THEN "," ELSE " " END, Var_NomCol, " DECIMAL(14,2)");

				END LOOP;
			END;
	CLOSE cursor_TablaImpuestos;

	-- Se asigna el nombre y campos de la tabla TMPIMPUESTOS
	SET Var_CreateTable := CONCAT(Var_CreateTable, ',NoFactura VARCHAR(20)', ',ProveedorID INT(11)', ',ImpuestoID INT(11)' "); ");

	SET @Sentencia  = (Var_CreateTable);
	PREPARE Tabla FROM @Sentencia;
	EXECUTE  Tabla;
	DEALLOCATE PREPARE Tabla;


	-- Tabla temporal para obtener el numero de columnas de impuestos
	DROP TABLE IF EXISTS tmpcolumnasimpuesto;
	CREATE TEMPORARY TABLE tmpcolumnasimpuesto(
		numColum 		INT(11),
		nombreColumna 	VARCHAR(40)
	);

	-- Se registra el numero de columnas de impuestos
	INSERT INTO tmpcolumnasimpuesto
		SELECT (@Var_ContColumna := @Var_ContColumna +1),COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'TMPIMPUESTOS' AND table_schema = DATABASE();

	-- Se obtiene las columnas de la tabla TMPIMPUESTOS
	SET Var_Columnas :=	(SELECT GROUP_CONCAT(COLUMN_NAME)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = 'TMPIMPUESTOS' AND table_schema = DATABASE() AND COLUMN_NAME !='NoFactura'
																	AND COLUMN_NAME !='ProveedorID'
																	AND COLUMN_NAME !='ImpuestoID' );
	-- Se obtiene las columnas de la tabla TMPIMPUESTOS
	SET Var_ColumnasTabla :=	(SELECT GROUP_CONCAT(CONCAT(COLUMN_NAME, ' ',COLUMN_TYPE) ORDER BY ORDINAL_POSITION)
									FROM INFORMATION_SCHEMA.COLUMNS
									WHERE TABLE_NAME = 'TMPIMPUESTOS'
										AND table_schema = DATABASE()  );
-- Se obtiene l numero maximo de columnas
	SET Var_NumMaxColumna	:= (SELECT MAX(numColum)  FROM tmpcolumnasimpuesto)- 3;

	-- Cursor para obtener la informacion de las Facturas
	OPEN  cursor_Datos;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH cursor_Datos  INTO Var_ProveedorID,Var_NoFactura,Var_MontoImpuesto,
					Var_ImpuestoID	, Var_DescripCorta;

					SET Var_DescripCorta 	:= REPLACE(Var_DescripCorta,' ','_');

					SET Var_NumColumna		:= (SELECT numColum  FROM tmpcolumnasimpuesto
												WHERE nombreColumna LIKE Var_DescripCorta limit 1);
					SET Var_NombreColumna	:= (SELECT nombreColumna  FROM tmpcolumnasimpuesto
												WHERE nombreColumna LIKE Var_DescripCorta limit 1);
					SET Var_NumColumna		:= IFNULL(Var_NumColumna, 0);
					SET Var_NombreColumna	:= IFNULL(Var_NombreColumna, '');

					IF(Var_ContadorDatos = 1 ) THEN
						SET Var_InsertValores  := CONCAT(Var_InsertValores,"(");
					ELSE
						SET Var_InsertValores  := CONCAT(Var_InsertValores,",(");
					END IF;

					WHILE Var_Contador <=  Var_NumMaxColumna DO
						 IF(Var_NumColumna = Var_Contador) THEN
							SET Var_InsertValores  := CONCAT(Var_InsertValores,Var_MontoImpuesto,",");
						 ELSE
							SET Var_InsertValores  := CONCAT(Var_InsertValores,0.00,",");
						END IF;
						SET Var_Contador	:= Var_Contador + 1;

					END WHILE;

					SET Var_InsertValores  := CONCAT(Var_InsertValores,"'",Var_NoFactura,"',",Var_ProveedorID,",",Var_ImpuestoID);

					IF(Var_ContadorDatos = Var_NumeroDatos) THEN
						SET Var_InsertValores  := CONCAT(Var_InsertValores,");");
					ELSE
						SET Var_InsertValores  := CONCAT(Var_InsertValores,")");
					END IF;

					SET Var_ContadorDatos	:= Var_ContadorDatos+1;
					SET Var_Contador	:= 1;
				END LOOP;
			END;
	CLOSE cursor_Datos;

	SET Var_InsertTable     := CONCAT(Var_InsertTable, Var_InsertValores);
	SET Var_QueryTable 		:= CONCAT('SUM(',REPLACE (Var_Columnas , ',',"),SUM(") , ')');

	-- Se obtiene el importe de los impuestos
	IF(Var_NumeroDatos>0)THEN
		DROP TABLE IF EXISTS TMPIMPORTEIMPUESTOS;
		SET Var_CreateTabImp     := CONCAT(	" CREATE TABLE TMPIMPORTEIMPUESTOS (", Var_ColumnasTabla , ");");
        SET Var_CreateTabIndice  := "CREATE INDEX id_indexImpuestos ON TMPIMPORTEIMPUESTOS (ProveedorID,NoFactura);";
		SET Var_InsertTabImp     := CONCAT(	" INSERT INTO TMPIMPORTEIMPUESTOS  SELECT ",Var_QueryTable,",NoFactura,ProveedorID,ImpuestoID FROM ", Var_NombreTabla, " GROUP BY ProveedorID, NoFactura, ImpuestoID;");

		SET @Sentencia  = (Var_InsertTable);
		PREPARE InsertarValores FROM @Sentencia;
		EXECUTE  InsertarValores;
		DEALLOCATE PREPARE InsertarValores;

		SET @Sentencia  = (Var_CreateTabImp);
		PREPARE CreateTable FROM @Sentencia;
		EXECUTE  CreateTable;
		DEALLOCATE PREPARE CreateTable;

        SET @Sentencia  = (Var_CreateTabIndice);
		PREPARE CreateTableIndice FROM @Sentencia;
		EXECUTE  CreateTableIndice;
		DEALLOCATE PREPARE CreateTableIndice;

		SET @Sentencia  = (Var_InsertTabImp);
		PREPARE InsertTable FROM @Sentencia;
		EXECUTE  InsertTable ;
		DEALLOCATE PREPARE InsertTable ;


	END IF;

END$$