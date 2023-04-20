# Proyecto Lince

El proyecto Lince surge de la necesidad de monitorear el coche Lince del IES Jándula en tiempo real sin la necesidad de llamar al alumno que lo maneja. 

## Objetivo

Este proyecto consiste en recoger información del coche con la ayuda de una placa arduino que envía dicha información a un Google Sheet, utilizando aplicaciones web desarrolladas con Google App Scripts. Además, obtengo y muestro dicha información en una página web.

## Requisitos

Para llevar a cabo este proyecto se necesitan los siguientes elementos:

- Una placa Arduino capaz de realizar peticiones a una URL y con sistema de geolocalización.
- Una tarjeta SIM que permita que la placa realice peticiones.
- Una clave de API de Google para mostrar un mapa de Google Maps en la página web.
- Un ordenador con los IDE correspondientes para los lenguajes utilizados en el proyecto (Arduino, Visual Studio Code) y conexión a internet.

## Diseño

El diseño de este proyecto consiste en la utilización de una placa Arduino que recopila información del coche y la envía a una hoja de cálculo de Google. Luego, mediante Google App Scripts, se accede a la información de la hoja de cálculo y se muestra en una página web utilizando el framework de Flutter.

## Lenguajes de programación utilizados

Este proyecto utiliza los siguientes lenguajes de programación:

- Arduino para la programación de la placa Arduino.
- Google App Scripts para el desarrollo de aplicaciones web que se encargan de recopilar información de la hoja de cálculo o escribir en ella.
- Dart con el framework de Flutter para el desarrollo de la página web.
