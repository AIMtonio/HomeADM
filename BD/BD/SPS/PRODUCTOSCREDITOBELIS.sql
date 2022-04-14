-- SP PRODUCTOSCREDITOBELIS

DELIMITER ;

DROP PROCEDURE IF EXISTS PRODUCTOSCREDITOBELIS;

DELIMITER $$

CREATE PROCEDURE `PRODUCTOSCREDITOBELIS`(
	Par_Descripcion		VARCHAR(100),
	Par_PerfilID		INT(11),
	Par_NumLis			TINYINT UNSIGNED,
	Par_EmpresaID		INT,

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

DECLARE	NumErr		 	INT(11);
DECLARE	ErrMen			VARCHAR(40);

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Lis_Principal 	INT(11);
DECLARE	Lis_Combo		INT(11);
DECLARE	Lis_Bancas		INT(11);
DECLARE	NoManejaLinea	CHAR(1);
DECLARE	Var_SI			CHAR(1);

DECLARE TipoClasifCom       CHAR(1);
DECLARE TipoClasifCon       CHAR(1);
DECLARE TipoClasifHip       CHAR(1);
DECLARE NomDispCom          VARCHAR(20);
DECLARE NomDispCon          VARCHAR(20);
DECLARE NomDispHip          VARCHAR(20);



SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 1;
SET Lis_Combo 		:= 2;
SET Lis_Bancas 		:= 3;
SET	NoManejaLinea 	:= 'N';
SET	Var_SI			:= 'S';

SET TipoClasifCom       := 'C';       
SET TipoClasifCon       := 'O';
SET TipoClasifHip       := 'H';
SET NomDispCom          := 'Comercial';
SET NomDispCon          := 'Consumo';
SET NomDispHip          := 'Hipotecario';

if(Par_NumLis = Lis_Principal) THEN
	SELECT	ProductoCreditoID,		Descripcion
	FROM PRODUCTOSCREDITOBE
	WHERE  Descripcion LIKE concat("%", Par_Descripcion, "%")
	LIMIT 0, 15;
END if;


IF(Par_NumLis = Lis_Combo) THEN
	SELECT	Pbe.ProductoCreditoID,		concat(convert(Pbe.ProductoCreditoID,char),' ',Pro.Descripcion) AS Descripcion
    FROM PRODUCTOSCREDITO Pro INNER JOIN PRODUCTOSCREDITOBE Pbe ON Pro.ProducCreditoID=Pbe.ProductoCreditoID
    WHERE Pro.Descripcion LIKE concat("%", Par_Descripcion, "%") AND PerfilID=Par_PerfilID;
END IF;

IF(Par_NumLis = Lis_Bancas) THEN
	SELECT	Pbe.ProductoCreditoID, 		Pro.Descripcion AS DesCredito, 		Des.DestinoCreID, 		Des.Descripcion AS DesDestino,	Des.Clasificacion AS ClasifChar,
			CASE Des.Clasificacion
			    WHEN TipoClasifCom THEN NomDispCom
			    WHEN TipoClasifCon THEN NomDispCon
			    WHEN TipoClasifHip THEN NomDispHip
			END AS Clasificacion	
    FROM PRODUCTOSCREDITOBE Pbe 
    INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID = Pbe.ProductoCreditoID
    INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Pbe.DestinoCreditoID;
END IF;


END TerminaStore$$