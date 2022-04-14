package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.CuentasCorreoBean;
import soporte.bean.NotariaBean;

public class CuentaCorreoDAO extends BaseDAO{

	public CuentaCorreoDAO() {
		super();
	}
	
	/* Consuta Notaria por Llave Foranea*/
	public CuentasCorreoBean consultaPrincipal(CuentasCorreoBean correoBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTASCORREOCON(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	correoBean.getCuentaCorreoID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CuentaCorreoDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCORREOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasCorreoBean cuentasCorreoBean = new CuentasCorreoBean();
					cuentasCorreoBean.setCorreoContactoCliente(resultSet.getString(1));
					cuentasCorreoBean.setAsuntoContactoCliente(resultSet.getString(2));
					cuentasCorreoBean.setCorreoPromocion(resultSet.getString(3));					
					cuentasCorreoBean.setAsuntoPromocion(resultSet.getString(4));
					cuentasCorreoBean.setCorreoRiesgos(resultSet.getString(5));
					cuentasCorreoBean.setAsuntoRiesgos(resultSet.getString(6));
					
					return cuentasCorreoBean;
	
			}
		});
				
		return matches.size() > 0 ? (CuentasCorreoBean) matches.get(0) : null;
	}

	
	
}
