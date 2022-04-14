DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2ENVIOCORREOPRO;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2ENVIOCORREOPRO (
	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(800),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Aud_EmpresaID 					INT(11), 				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(14,2);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE Entero_Uno				INT(11);				-- Entero uno

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de Control
	DECLARE Var_Consecutivo			BIGINT(20);				-- Consecutivo
	DECLARE Var_RegistroActual		INT(11);				-- Variable del registro actual para el iterador
	DECLARE Var_TotalRegistros		INT(11);				-- Variable para el total de registros a iterar
	DECLARE Var_ClienteID			INT(11);				-- Numero de Cliente
	DECLARE Var_RutaPDF				VARCHAR(2000);			-- Ruta del archivo PDF
	DECLARE Var_PesoPDF				LONG;					-- Peso del archivo PDF
	DECLARE Var_RutaXML				VARCHAR(2000);			-- Ruta del archivo XML
	DECLARE Var_PesoXML				LONG;					-- Peso del archivo XML

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0;					-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET Entero_Uno					:= 1;					-- Entero uno

	SELECT		COUNT(pdf.ClienteID)
		INTO	Var_TotalRegistros
		FROM EDOCTAV2DATOSCTE AS cte
		INNER JOIN CLIENTES AS cli ON cte.ClienteID = cli.ClienteID
		INNER JOIN EDOCTAV2PARAMS AS params ON cte.AnioMes = params.MesProceso
		INNER JOIN EDOCTAV2PDFGENERADOS AS pdf ON cte.AnioMes = pdf.AnioMes AND cte.ClienteID = pdf.ClienteID
		LEFT JOIN EDOCTAV2XMLGENERADOS AS xml ON pdf.AnioMes = xml.AnioMes AND pdf.ClienteID = xml.ClienteID
		WHERE IFNULL(cli.Correo, Cadena_Vacia) <> Cadena_Vacia;

	SET Var_RegistroActual		:= Entero_Cero;

	IteraRegistros: WHILE (Var_RegistroActual < Var_TotalRegistros) DO
		SELECT		pdf.ClienteID,	MAX(pdf.RutaArchivo),	MAX(pdf.PesoByte),	IFNULL(MAX(xml.RutaArchivo), Cadena_Vacia),	IFNULL(MAX(xml.PesoByte), Entero_Cero)
			INTO	Var_ClienteID,	Var_RutaPDF,			Var_PesoPDF,		Var_RutaXML,								Var_PesoXML
			FROM EDOCTAV2DATOSCTE AS cte
			INNER JOIN CLIENTES AS cli ON cte.ClienteID = cli.ClienteID
			INNER JOIN EDOCTAV2PARAMS AS params ON cte.AnioMes = params.MesProceso
			INNER JOIN EDOCTAV2PDFGENERADOS AS pdf ON cte.AnioMes = pdf.AnioMes AND cte.ClienteID = pdf.ClienteID
			LEFT JOIN EDOCTAV2XMLGENERADOS AS xml ON pdf.AnioMes = xml.AnioMes AND pdf.ClienteID = xml.ClienteID
			WHERE IFNULL(cli.Correo, Cadena_Vacia) <> Cadena_Vacia
			GROUP BY pdf.ClienteID, xml.ClienteID
			LIMIT Var_RegistroActual, Entero_Uno;

		CALL EDOCTAV2TARARCHIVOCORREOPRO (	Var_ClienteID,		Var_RutaPDF,		Var_PesoPDF,	Var_RutaXML,	Var_PesoXML,
											Var_SalidaNO,		Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		SET Var_RegistroActual	:= Var_RegistroActual + Entero_Uno;
	END WHILE IteraRegistros;

	SET Par_NumErr	:= Entero_Cero;
	SET Par_ErrMen	:= 'Proceso de registro de archivos adjuntos finalizado exitosamente';
	SET Var_Control	:= 'EnvioCorreoID';

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$
