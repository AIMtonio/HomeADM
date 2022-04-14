package seguimiento.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import seguimiento.bean.CatSegtoCategoriasBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class CategoriaSegtoDAO extends BaseDAO{
	public CategoriaSegtoDAO(){
		super();
	}

	/* Lista de Categorias de Seguimiento*/
	public List categoriaCombo(int tipoLista) {
		//Query con el Store Procedure
		String query = "call SEGTOCATEGORIASLIS(?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOCATEGORIASLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatSegtoCategoriasBean categorias = new CatSegtoCategoriasBean();
				categorias.setCategoriaID(resultSet.getString("CategoriaID"));
				categorias.setDescripcion(resultSet.getString("Descripcion"));
				return categorias;
			}
		});
		return matches;
	}
}
