package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import originacion.bean.CatdatsocioeBean;

public class CatDatSocioEDAO extends BaseDAO{

	public CatDatSocioEDAO(){
		super();
	}
	
	/* Consuta Principal */
	public CatdatsocioeBean consultaPrincipal(CatdatsocioeBean catdatsocioeBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CATDATSOCIOECON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								catdatsocioeBean.getCatSocioEID(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATDATSOCIOECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatdatsocioeBean catdatsocioe = new CatdatsocioeBean();
				
				catdatsocioe.setCatSocioEID(resultSet.getString("catSocioEID"));
				catdatsocioe.setDescripcion(resultSet.getString("Descripcion"));
				catdatsocioe.setTipo(resultSet.getString("Tipo"));
				catdatsocioe.setEstatus(resultSet.getString("Estatus"));
				
				return catdatsocioe;
	
			}
		});
				
		return matches.size() > 0 ? (CatdatsocioeBean) matches.get(0) : null;
	}
}
