package main

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"

	beego "github.com/beego/beego/v2/server/web"

	"xchango_crud/controllers"
	_ "xchango_crud/routers"
)

func main() {
	conexion := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		beego.AppConfig.DefaultString("bd_host", "localhost"),
		beego.AppConfig.DefaultString("bd_puerto", "5432"),
		beego.AppConfig.DefaultString("bd_usuario", "postgres"),
		beego.AppConfig.DefaultString("bd_clave", ""),
		beego.AppConfig.DefaultString("bd_nombre", "db_xchango"))

	bd, err := sql.Open("postgres", conexion)
	if err != nil {
		fmt.Println("No se pudo abrir la base de datos:", err)
		return
	}

	// probamos la conexion antes de arrancar
	err = bd.Ping()
	if err != nil {
		fmt.Println("No se pudo conectar a PostgreSQL, revisa conf/app.conf:", err)
		return
	}
	fmt.Println("Conectado a PostgreSQL")

	controllers.BD = bd

	beego.Run()
}
