package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import tarjetas.bean.CatalogoBloqueoCancelacionTarDebitoBean;


public class CatalogoBloqueoCancelacionTarDebitoDAO extends BaseDAO{
 
	public CatalogoBloqueoCancelacionTarDebitoDAO(){
		super();
	}
	
	public List listaCatalogoMotivoBloq( int tipoLista, CatalogoBloqueoCancelacionTarDebitoBean catalogoTarDebBean) {
		//Query con el Store Procedure
		String query = "call CATALCANBLOQTARLIS(?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CatalogoTarDebBean.listaCatalogoTar",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALCANBLOQTARLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoBloqueoCancelacionTarDebitoBean catalogo = new CatalogoBloqueoCancelacionTarDebitoBean();
				catalogo.setMotCanBloID(String.valueOf(resultSet.getString(1)));
				catalogo.setDescripcion(resultSet.getString(2));
		
				return catalogo;
			}
		});
		return matches;
	}
	
}
